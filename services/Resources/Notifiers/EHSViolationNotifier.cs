using Newtonsoft.Json.Linq;
using NLog;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using services.Resources.Notifiers.Helpers;
using services.Models;
using services.ExtensionMethods;

namespace services.Resources.Notifiers
{
    public class EHSViolationNotifier
    {
        private static string ROUTEEVENTTYPE = "EHSInspectionViolation";

        private static Logger logger = LogManager.GetCurrentClassLogger();

        public static void notify(EHSViolation in_violation, List<string> routes){

            logger.Debug("notify for ID: " + in_violation.Id + " with routes: " + routes.Count);

            //string PermitURL = System.Configuration.ConfigurationManager.AppSettings["EmailPermitURL"];
            //string PermitProjectId = System.Configuration.ConfigurationManager.AppSettings["PermitProjectId"];

            List<string> recipients = null;

            //recipients = in_recipients.Properties().Select(p => p.Name).ToList();
            recipients = EHSViolationRouteHelper.getRecipientsForRoute(ROUTEEVENTTYPE, routes);

            logger.Debug("count of recipients = " + recipients.Count);

            //if no recipients, no notification needed
            if (recipients.Count == 0)
                return;

            string subject = "EHS "+ in_violation.FileType+" Notification";

            logger.Debug("Sending to " + recipients.Count + " - " + subject);

            string body = "<h3>EHS " + in_violation.FileType + " notification</h3>";
            body += "<p>The Environmental Health & Safety Program just created a new record and asked that you be notified, please review the below information and contact " + in_violation.Reviewer + " for any additional information or with your thoughts:</p>";

            var db = ServicesContext.Current;

            List<string> parcels = db.EHSViolationParcels().Where(o => o.EHSViolationId == in_violation.Id).Select(o => o.ParcelId).ToList<string>();
            List<string> parties = db.EHSViolationContacts().Where(o => o.EHSViolationId == in_violation.Id).Select(o => o.PermitPerson.FullName).ToList<string>();

            body += "<p><b>Create Date</b>: " + in_violation.CreateDate.ToShortDateString() + "</p>";
            body += "<p><b>File Number</b>: " + in_violation.FileNumber + "</p>";
            body += "<p><b>Type of Record</b>: " + in_violation.FileType + "</p>";
            body += "<p><b>Reviewer</b>: " + in_violation.Reviewer + "</p>";
            body += "<p><b>Violation Offenses</b>: " + in_violation.ViolationOffenses.Replace("[", "").Replace("]", "") + "</p>";
            body += "<p><b>Involved Parcels</b>: " + string.Join(",",parcels) + "</p>";
            body += "<p><b>Involved Parties</b>: " + string.Join(",",parties) + "</p>";
            body += "<p><b>Complaint Description</b>: " + in_violation.ComplaintDescription + "</p>";
            body += "<p><b>Violation Description</b>: " + in_violation.ViolationDescription + "</p>";


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