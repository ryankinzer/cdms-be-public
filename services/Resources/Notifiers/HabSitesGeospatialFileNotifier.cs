using Newtonsoft.Json.Linq;
using NLog;
using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Resources
{
    public class HabSitesGeospatialFileNotifier
    {
        public static Logger logger = LogManager.GetCurrentClassLogger();

        public static void notify(HabitatItem item, Project project)
        {

            List<string> recipients = new List<string> { System.Configuration.ConfigurationManager.AppSettings["HabSitesGeospatialFileEmailTo"] };

            User poster = AuthorizationManager.getCurrentUser();

            string subject = "CDMS User posted Habitat Item with Geographic File";

            string body = "<h3>Geographic File posted by user: " + poster.Fullname + "</h3>";
            
            body += "<p><b>Project</b>: " + project.Name + "</p>";
            body += "<p><b>Sub Project</b>: " + item.Subproject.ProjectName + "</p>";
            body += "<p><b>Item Name</b>: " + item.ItemName + "</p>";
            body += "<p><b>Item Type</b>: " + item.ItemType + "</p>";

            body += "<hr/><p><b>Documents</b>: <br/>";

            JArray files = JArray.Parse(item.ItemFiles);
            foreach (dynamic file in files)
            {
                body += "<a href='" + file.Link + "'>" + file.Name;
                body += "</a><br/>";
            }


            try
            {
                EmailHelper.SendEmail(recipients, "noreply@ctuir.org", subject, body, null, "HabSitesGeoFile");
                logger.Debug("Sent an email to " + recipients.ToString()); 
            }
            catch (Exception e)
            {
                logger.Debug("Well that didn't work out: " + e.Message);
                logger.Debug(e.InnerException);
                throw e;
            }

        }
    }
}