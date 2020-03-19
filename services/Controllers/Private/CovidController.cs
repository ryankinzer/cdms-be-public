using Newtonsoft.Json.Linq;
using services.Models;
using services.Resources;
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

            var sql = @"select * from COVID_Employees where SupervisorUsername = '" + me.Username + "' ORDER BY Name";

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

            var sql = @"select w.* from COVID_EmployeesWork w JOIN COVID_Employees e ON w.EmployeeId = e.Id where e.SupervisorUsername = '" + me.Username + "'" ;

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

            foreach (var employee in json.Employees)
            {
                //save employee
                //save employee work
            }

            return new HttpResponseMessage(HttpStatusCode.OK);


        }

    }
}