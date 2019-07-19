using NLog;
using services.Models;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Resources
{
    public class FeedbackNotifier
    {
        public static Logger logger = LogManager.GetCurrentClassLogger();

        public static void notify(Feedback feedback){

            List<string> recipients = new List<string> { System.Configuration.ConfigurationManager.AppSettings["FeedbackEmailTo"] };

            User poster = AuthorizationManager.getCurrentUser();

            string subject = "CDMS Feedback posted from:" + poster.Username;
            
            string body = "<h3>Feedback just in from a user: " + poster.Fullname + "</h3>";
            body += "<p><b>Title</b>: " + feedback.Title + "</p>";
            body += "<p><b>Message</b>: " + feedback.Message+ "</p>";
            body += "<p><b>Module</b>: " + feedback.Module+ "</p>";
            body += "<p><b>Submitter Name</b>: " + feedback.SubmitterName+ "</p>";
            body += "<p><b>Submit Date</b>: " + feedback.SubmitDate + "</p>";

            try
            {
                EmailHelper.SendEmail(recipients, "noreply@ctuir.org", subject, body);
                logger.Debug("Sent an email to " + recipients.ToString()); //TODO: save in the notification log
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