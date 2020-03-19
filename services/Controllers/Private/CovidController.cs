using Newtonsoft.Json.Linq;
using services.Models;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace services.Controllers.Private
{
    public class CovidController : CDMSController
    {
        [HttpGet]
        public dynamic SupervisedEmployees()
        {
            User me = AuthorizationManager.getCurrentUser();

            var sql = @"select * from COVID_Employees where SupervisorUsername = '" + me.Username + "' OR DeptSupervisorUsername = '" + me.Username + "' ORDER BY Name";

            DataTable requests = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(requests);
                }
            }

            return requests;

        }


        [HttpGet]
        public dynamic SupervisedEmployeesWork()
        {
            User me = AuthorizationManager.getCurrentUser();

            var sql = @"select w.* from COVID_EmployeesWork w JOIN COVID_Employees e ON w.EmployeeId = e.Id where e.SupervisorUsername = '" + me.Username + "' OR DeptSupervisorUsername = '" + me.Username + "'" ;

            DataTable requests = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(requests);
                }
            }

            return requests;

        }

        [HttpPost]
        public HttpResponseMessage SaveEmployees(JObject jsonData)
        {
            dynamic json = jsonData;

            User me = AuthorizationManager.getCurrentUser(); //only can update employees they are supervisors for

            List<string> employeeFields = new List<string> { "Department","Email","Id","Name","Program","Status","Access","SupervisorUsername","DeptSupervisorUsername","Title","IsHighRisk","IsUnique","IsSick","Notes" };

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();

                foreach (var employee in json.Employees)
                {
                    //save employee
                    string EmployeeId = employee.Id.ToObject<int>().ToString();
                    string Status = QueryHelper.filterForSQL(employee.Status.ToObject<string>());
                    string Access = QueryHelper.filterForSQL(employee.Access.ToObject<string>());
                    string IsHighRisk = QueryHelper.filterForSQL(employee.IsHighRisk.ToObject<string>());
                    string IsUnique = QueryHelper.filterForSQL(employee.IsUnique.ToObject<string>());
                    string IsSick = QueryHelper.filterForSQL(employee.IsSick.ToObject<string>());
                    string Notes = QueryHelper.filterForSQL(employee.Notes.ToObject<string>(), true);

                    //TODO: it would be nice to detect updated records instead of just updating all... or maybe just send updated records from the FE... yes, do that. :)                    

                    var query = @"UPDATE COVID_Employees SET [Status] = '" + Status + "'" +
                        ", [IsHighRisk] = '" + IsHighRisk + "' "+
                        ", [IsUnique] = '" + IsUnique + "' " +
                        ", [IsSick] = '" + IsSick + "' " +
                        ", [Notes] = '" + Notes + "' " +
                        "WHERE Id = " + EmployeeId + " AND (SupervisorUsername = '" + me.Username + "' OR DeptSupervisorUsername = '" + me.Username + "')";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        //logger.Debug(query);
                        cmd.ExecuteNonQuery();
                    }

                    //save employee work
                    foreach(JProperty property in employee.Properties()){
                        if(!employeeFields.Contains(property.Name)){
                            //if it exists, update
                            var exists_sql = @"SELECT Id FROM COVID_EmployeesWork WHERE EmployeeId = " + EmployeeId + " AND WorkDate = '" + property.Name + "'";

                            int IdToUpdate = 0;

                            using (SqlCommand cmd = new SqlCommand(exists_sql, con))
                            {
                                //logger.Debug(exists_sql);
                                try
                                {
                                    IdToUpdate = (int)cmd.ExecuteScalar();
                                }catch(Exception e){
                                    // doesn't exist;
                                }
                            }

                            if(IdToUpdate != 0){
                                var update_sql = @"UPDATE COVID_EmployeesWork SET WorkStatus = '" + property.Value + "' WHERE Id = " + IdToUpdate.ToString();

                                using (SqlCommand cmd = new SqlCommand(update_sql, con)){
                                    //logger.Debug(update_sql);
                                    cmd.ExecuteNonQuery();
                                }
                            } else {
                                var insert_sql = @"INSERT INTO COVID_EmployeesWork (EmployeeId, WorkDate, WorkStatus) VALUES (" + EmployeeId + ", '"+ property.Name + "','" + property.Value +"')";

                                using (SqlCommand cmd = new SqlCommand(insert_sql, con))
                                {
                                    //logger.Debug(insert_sql);
                                    cmd.ExecuteNonQuery();
                                }
                            }
                        }
                    }
                }
            }

            return new HttpResponseMessage(HttpStatusCode.OK);


        }

    }
}