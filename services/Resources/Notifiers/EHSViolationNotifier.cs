using Newtonsoft.Json.Linq;
using NLog;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using services.Resources.Notifiers.Helpers;

namespace services.Resources.Notifiers
{
    public class EHSViolationNotifier
    {
        private static string ROUTEEVENTTYPE = "EHSViolationInspection";

        private static Logger logger = LogManager.GetCurrentClassLogger();

        public static void notify(EHSViolation in_violation, List<string> routes){

            logger.Debug("notify for ID: " + in_violation.Id + " with routes: " + routes.Count);

            //string PermitURL = System.Configuration.ConfigurationManager.AppSettings["EmailPermitURL"];
            //string PermitProjectId = System.Configuration.ConfigurationManager.AppSettings["PermitProjectId"];

            List<string> recipients = null;

            //recipients = in_recipients.Properties().Select(p => p.Name).ToList();
            recipients = EHSViolationRouteHelper.getRecipientsForRoute(ROUTEEVENTTYPE, routes);

            //if no recipients, no notification needed
            if (recipients.Count == 0)
                return;

            string subject = "EHS "+ in_violation.FileType+" Notification";

            logger.Debug("Sending to " + recipients.Count + " - " + subject);

            string body = "<h3>EHS " + in_violation.FileType + " notification</h3>";

            if (in_violation.FileType == "Complaint")
            {
                //body += "<p><b>Permit</b>: <a href='" + PermitURL + in_permit.Id + "'>" + in_permit.PermitNumber + "</a></p>"; //TODO: Phase 2 will provide a link to reviewers
                body += "<p><b>Create Date</b>: " + in_violation.CreateDate.ToShortDateString() + "</p>";
                body += "<p><b>File Number</b>: " + in_violation.FileNumber + "</p>";
                body += "<p><b>Name</b>: " + in_violation.Name + "</p>";
                body += "<p><b>Offenses</b>: " + in_violation.ViolationOffenses + "</p>";
                body += "<p><b>Description</b>: " + in_violation.ViolationDescription + "</p>";
                
            }
            
            if(in_violation.FileType == "Violation"){
                body += "<p><b>Create Date</b>: " + in_violation.CreateDate.ToShortDateString() + "</p>";
                body += "<p><b>File Number</b>: " + in_violation.FileNumber + "</p>";
                body += "<p><b>Name</b>: " + in_violation.Name + "</p>";
                body += "<p><b>Offenses</b>: " + in_violation.ViolationOffenses + "</p>";
                body += "<p><b>Description</b>: " + in_violation.ViolationDescription + "</p>";
            }

            if (in_violation.Comments != null)
                body += "<hr/><p><b>Comments</b>: "+ in_violation.Comments;

            body += "<br/><br/> -- Please contact CTUIR Environmental Health & Safety at 541-429-7522 with any questions.<br/>Thank you!";

            string attachment = null;

           

            try
            {
                EmailHelper.SendEmail( recipients, "coleemayfield@ctuir.org", subject, body, attachment, "EHSInspectionViolation");

                logger.Debug("Sent an email to " + recipients.ToString()); 
            }
            catch (Exception e)
            {
                logger.Debug("Well that didn't work out: " + e.Message);
                logger.Debug(e.InnerException);
            }

        }


    }
}