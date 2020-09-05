using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using CsvHelper;
using Newtonsoft.Json.Linq;
using NLog;

namespace services.Resources
{
    /**
     * Reads a CSV file and return
     */ 
    public class CSVReader
    {
		public static Logger logger = LogManager.GetCurrentClassLogger();
		private string fileName;

        public CSVReader(string a_fileName)
        {
            this.fileName = a_fileName;


        }

        internal ImportDataResult getImportDataResult(int start_on_line = 1)
        {
            ImportDataResult dataresult = new ImportDataResult();
            var rows = new List<JObject>();
            var num_to_skip = start_on_line - 1;

            List<string> columns = new List<string>();

            using (var reader = new StreamReader(fileName))
            {
                for (int i = 0; i < num_to_skip; i++)
                {
                    reader.ReadLine(); //skip one line.    
                }

                CsvParser csvParser = new CsvParser(reader);
                string[] headers = csvParser.Read();
				int h = 0;
                foreach (string header in headers)
                {
                    string header_val = header;


					if (columns.Contains(header))
					{
						logger.Debug(">>>>Renaming duplicate column name!!: " + header);
						header_val = header_val + "_DuplicateColumnName_" + h;
					}
					else {
						logger.Debug(">>>>Header: " + header);
					}
						
					if (header == "" || header == null)
                        header_val = "-blank-";

                    columns.Add(header_val);
					++h;
                }

                dataresult.columns = columns;

                //now we have the columns... lets get the rows!
                string[] line;

                while ((line = csvParser.Read()) != null) //NOTE: reader.EndOfStream does NOT work here. :(
                {
                    var idx = 0;
                    var row = new JObject();

                    //iterate our columns and copy
                    foreach (var column in columns)
                    {
                        row.Add(new JProperty(column, line[idx]));
                        idx++;
                    }

                    rows.Add(row);
                }

                dataresult.rows = rows;
            }

            return dataresult;
        }

        


    }
}