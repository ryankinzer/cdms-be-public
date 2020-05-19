using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Data;
using NPOI.SS.UserModel;
using NPOI.HSSF.UserModel;
using NLog;
using System.Text;
using System.Dynamic;

namespace services.Resources
{
    public class ExcelReader2
    {
        public static Logger logger = LogManager.GetCurrentClassLogger();
        public static bool blnHasError = false;
        public static string strErrorMessage = "";

        string _path;
        DataTable dataTable = null;

        public ExcelReader2(string path)
        {
            _path = path;
            dataTable = null;
            blnHasError = false;
            strErrorMessage = "";
            dataTable = ReadExcelFile(_path, 0); // 0 = The first worksheet.
        }

        public DataTable ReadExcelFile(string strFilePathAndName, int intSheetIndex)
        {
            logger.Debug("Inside ExcelReader2.cs, ReadExcelFile...");
            try
            {
                if (System.IO.File.Exists(strFilePathAndName))
                {
                    logger.Debug("File " + strFilePathAndName + " exists...");
                    IWorkbook workbook = null;  //IWorkbook determines if it is xls or xlsx             
                    ISheet worksheet = null;
                    string strFirstSheetName = "";

                    using (FileStream FS = new FileStream(strFilePathAndName, FileMode.Open, FileAccess.Read))
                    {
                        workbook = WorkbookFactory.Create(FS);              //Opens both XLS and XLSX
                        worksheet = workbook.GetSheetAt(intSheetIndex);     //Get Sheet by Index
                        strFirstSheetName = worksheet.SheetName;            //Get the name of the sheet

                        dataTable = new DataTable(strFirstSheetName);
                        dataTable.Rows.Clear();
                        dataTable.Columns.Clear();

                        // Read Row by row from the first
                        for (int rowIndex = 0; rowIndex <= worksheet.LastRowNum; rowIndex++)
                        {
                            DataRow NewRow = null;
                            IRow row = worksheet.GetRow(rowIndex);
                            IRow row2 = null;
                            IRow row3 = null;

                            if (rowIndex == 0)
                            {
                                row2 = worksheet.GetRow(rowIndex + 1); //If it is the first row, I also get the second to know the data type
                                row3 = worksheet.GetRow(rowIndex + 2); //And the third also for the doubts
                            }

                            if (row != null) //null is when the row only contains empty cells 
                            {
                                if (rowIndex > 0) NewRow = dataTable.NewRow();

                                int colIndex = 0;
                                //Read each Column in the row
                                foreach (ICell cell in row.Cells)
                                {
                                    //logger.Debug("Col Value:  " + cell);

                                    object cellValue = null;
                                    string cellType = "";
                                    string[] cellType2 = new string[2];
                                    int intRowId = 0;

                                    if (rowIndex == 0) //I assume that the first row contains the titles:
                                    {
                                        for (int i = 0; i < 2; i++)
                                        {
                                            //logger.Debug("row = " + i);
                                            //logger.Debug("col = " + cell.ColumnIndex);
                                            ICell cell2 = null;
                                            if (i == 0) { cell2 = row2.GetCell(cell.ColumnIndex); intRowId = rowIndex + 1; }
                                            else { cell2 = row3.GetCell(cell.ColumnIndex); intRowId = rowIndex + 2; }

                                            //logger.Debug("cell2 = " + cell2);
                                            //logger.Debug("cell2.CellType = " + cell2.CellType);

                                            if (cell2 != null)
                                            {
                                                //if (cell2.CellType == null)
                                                //{
                                                //    cell2.SetCellType(CellType.Unknown);
                                                //    cellValue = DBNull.Value;
                                                //}

                                                switch (cell2.CellType)
                                                {
                                                    case CellType.Blank: break;
                                                    case CellType.Boolean: cellType2[i] = "System.Boolean"; break;
                                                    case CellType.String: cellType2[i] = "System.String"; break;
                                                    case CellType.Numeric:
                                                        if (HSSFDateUtil.IsCellDateFormatted(cell2))
                                                        {
                                                            // Turned the following code off, for the following reason.
                                                            // A date number value for 11/24/2014 is 41969.
                                                            // A date/time number value for 11/24/2014 1:00 is 41969.01466666664
                                                            // How to tell the difference between an incorrect fractional value,
                                                            // and a legitimate date/time value?

                                                            // To initialize a Date time, it always needs at least one int.
                                                            // So, if our incoming value is a fractional value like 123456.12345,
                                                            // (a Northing or Easting), it will not go into a Date cell; it will cause 
                                                            // an error/crash.
                                                            //int intCellValue = (int)cell2.NumericCellValue;
                                                            //if (intCellValue != cell2.NumericCellValue)
                                                            //{
                                                            //    logger.Debug("(zero based): rowIndex = " + intRowId + ", colIndex = " + cell.ColumnIndex + ", Cannot convert fractional value to date.");
                                                            //    blnHasError = true;
                                                            //    strErrorMessage = "(zero based): rowIndex = " + intRowId + ", colIndex = " + cell.ColumnIndex + ", Cannot convert fractional value to date.";
                                                            //    logger.Debug("strErrorMessage = " + strErrorMessage);
                                                                //return dataTable;
                                                            //    throw new System.ArgumentException("(zero based) rowIndex = " + intRowId + ", colIndex = " + cell.ColumnIndex + ", Cannot convert fractional value to date.");
                                                            //}
                                                            cellType2[i] = "System.DateTime";
                                                        }
                                                        else
                                                        {
                                                            cellType2[i] = "System.Double";  //valueCell = cell2.NumericCellValue;
                                                        }
                                                        break;

                                                    case CellType.Formula:
                                                        bool blnContinue = true;
                                                        switch (cell2.CachedFormulaResultType)
                                                        {
                                                            case CellType.Boolean: cellType2[i] = "System.Boolean"; break;
                                                            case CellType.String: cellType2[i] = "System.String"; break;
                                                            case CellType.Numeric:
                                                                if (HSSFDateUtil.IsCellDateFormatted(cell2)) { cellType2[i] = "System.DateTime"; }
                                                                else
                                                                {
                                                                    try
                                                                    {
                                                                        //DETERMINE IF BOOLEAN
                                                                        if (cell2.CellFormula == "TRUE()") { cellType2[i] = "System.Boolean"; blnContinue = false; }
                                                                        if (blnContinue && cell2.CellFormula == "FALSE()") { cellType2[i] = "System.Boolean"; blnContinue = false; }
                                                                        if (blnContinue) { cellType2[i] = "System.Double"; blnContinue = false; }
                                                                    }
                                                                    catch { }
                                                                }
                                                                break;
                                                        }
                                                        break;
                                                    default:
                                                        cellType2[i] = "System.String"; break;
                                                }
                                            }
                                            else
                                            {
                                                logger.Debug("cell2 = null; skipping...");
                                            }
                                        }

                                        //Resolve Type differences
                                        //if (cellType2[0] == cellType2[1]) { cellType = cellType2[0]; }
                                        if (cellType2[0] == cellType2[1])
                                        {
                                            // Are the values in the same column of both rows null?
                                            if ((cellType2[0] == null) && (cellType2[1] == null))
                                            {
                                                if (cellType == "") cellType = "System.String";
                                            }
                                            else
                                            {
                                                cellType = cellType2[0];
                                            }
                                        }
                                        else
                                        {
                                            if (cellType2[0] == null) cellType = cellType2[1];
                                            if (cellType2[1] == null) cellType = cellType2[0];
                                            if (cellType == "") cellType = "System.String";
                                        }

                                        //Get the Column name
                                        string colName = "Column_{0}";
                                        try { colName = cell.StringCellValue; }
                                        catch { colName = string.Format(colName, colIndex); }

                                        //Verify that the Column Name is NOT repeated
                                        foreach (DataColumn col in dataTable.Columns)
                                        {
                                            if (col.ColumnName == colName) colName = string.Format("{0}_{1}", colName, colIndex);
                                        }

                                        //Add the fields of the table:
                                        DataColumn dataColumn = new DataColumn(colName, System.Type.GetType(cellType));
                                        dataTable.Columns.Add(dataColumn); colIndex++;
                                    }
                                    else
                                    {
                                        //if (cell.CellType == null)
                                        //{
                                        //    cell.SetCellType(CellType.Unknown);
                                        //    cellValue = DBNull.Value;
                                        //}

                                        //The other rows are records:
                                        switch (cell.CellType)
                                        {
                                            case CellType.Blank: cellValue = DBNull.Value; break;
                                            case CellType.Boolean: cellValue = cell.BooleanCellValue; break;
                                            case CellType.String: cellValue = cell.StringCellValue; break;
                                            case CellType.Numeric:
                                                if (HSSFDateUtil.IsCellDateFormatted(cell))
                                                {
                                                    //logger.Debug("cell.NumericCellValue = " + cell.NumericCellValue);
                                                    //int intCellValue = (int)cell.NumericCellValue;
                                                    //if (intCellValue != cell.NumericCellValue)
                                                    //{
                                                    //    logger.Debug("(zero based) rowIndex = " + rowIndex + ", colIndex = " + cell.ColumnIndex + ", Cannot convert fractional value to date.");
                                                    //    blnHasError = true;
                                                    //    strErrorMessage = "(zero based) rowIndex = " + rowIndex + ", colIndex = " + cell.ColumnIndex + ", Cannot convert fractional value to date.";
                                                    //    return dataTable;
                                                    //    //throw new System.ArgumentException("Cannot convert fractional value to date.");
                                                    //}
                                                    cellValue = cell.DateCellValue;
                                                }
                                                else { cellValue = cell.NumericCellValue; }
                                                break;
                                            case CellType.Formula:
                                                switch (cell.CachedFormulaResultType)
                                                {
                                                    case CellType.Blank: cellValue = DBNull.Value; break;
                                                    case CellType.String: cellValue = cell.StringCellValue; break;
                                                    case CellType.Boolean: cellValue = cell.BooleanCellValue; break;
                                                    case CellType.Numeric:
                                                        if (HSSFDateUtil.IsCellDateFormatted(cell)) { cellValue = cell.DateCellValue; }
                                                        else { cellValue = cell.NumericCellValue; }
                                                        break;
                                                }
                                                break;
                                            default: cellValue = cell.StringCellValue; break;
                                        }
                                        //Add the new Record
                                        if (cell.ColumnIndex <= dataTable.Columns.Count - 1) NewRow[cell.ColumnIndex] = cellValue;
                                    }
                                }
                            }
                            //if (rowIndex > 0) dataTable.Rows.Add(NewRow);
                            if (rowIndex > 0) dataTable.Rows.Add(NewRow.ItemArray);
                        }
                        dataTable.AcceptChanges();
                    }
                }
                else
                {
                    throw new Exception("ERROR 404: The specified file does NOT exist.");
                }
            }
            catch (Exception ex)
            {
                logger.Debug("ex = " + ex.Message); // + ", " + ex.InnerException);
                throw ex;
            }
            return dataTable;
        }

        public IEnumerable<String> getColumns()
        {
            //logger.Debug("Inside ExcelReader2, getColumns...");

            var column_list = new List<String>();

            foreach (DataColumn col in dataTable.Columns)
            {
                column_list.Add(col.ColumnName);
            }

            /*foreach (var item in column_list)
            {
                logger.Debug("item = " + item);
            }
            */
            return column_list;
        }

        public IEnumerable<dynamic> getData(bool firstRowIsColumnNames = true)
        {
            var rows = from DataRow a in dataTable.Rows select a;

            // Debug lines, if we need to see what was/is in the rows.
            //string strRow = "";
            StringBuilder stringBuilder = new StringBuilder();
            int intR = 0;
            int intC = 0;
            List<dynamic> lstRows = new List<dynamic>();
            var columns = getColumns();

            foreach (var row in rows)
            {
                var kvRecord = new ExpandoObject() as IDictionary<string, dynamic>;
                intC = 0;

                foreach (var col in columns)
                {
                    //logger.Debug("col = " + col + ", row.ItemArray[intC] = " + row.ItemArray[intC]);
                    kvRecord.Add(col, row.ItemArray[intC]);

                    intC++;
                }
        
                intR++;
                intC++;
                //logger.Debug("intR = " + intR);
                lstRows.Add(kvRecord);
            }

            return lstRows.AsEnumerable();
        }

        public bool HasReadError()
        {
            return blnHasError;
        }

        public string GetErrorMessage()
        {
            return strErrorMessage;
        }
    }
}