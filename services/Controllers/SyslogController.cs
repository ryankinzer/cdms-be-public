using Newtonsoft.Json.Linq;
using services.Models;
using services.Resources;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Http;

namespace services.Controllers
{
    public class SyslogController : CDMSController
    {
        [HttpPost]
        public string SystemLog(JObject jsonData)
        {
            dynamic json = jsonData;

            if (jsonData.GetValue("Type").ToString() == "AUDIT")
            {
                logger.Info(jsonData.GetValue("Message").ToString().Substring(0, 255));
            }
            else
            {
                logger.Error(jsonData.GetValue("Message").ToString().Substring(0, 255));
            }

            return "{Message: 'Success'}";
        }

        [HttpGet]
        public dynamic GetNotificationsByModule(string Module)
        {
            User me = AuthorizationManager.getCurrentUser();
            var db = ServicesContext.Current;

            return db.NotificationLog.Where(o => o.Module == Module).OrderByDescending(o => o.SentDate).Take(50).AsEnumerable();

        }
    }
}
