using NLog;
using services.Models.Data;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Resources
{
    public class PermitEventNotifier
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();

        public static void notify(Permit in_permit, PermitEvent in_event){

            string PermitURL = System.Configuration.ConfigurationManager.AppSettings["EmailPermitURL"]; 

            string recipient = PermitEventNotifier.getEmailContactForEvent(in_event);

            string subject = in_event.EventType + " Request from TPO for " + in_event.ItemType;
            if(in_permit.ReviewedBy != null){
                subject += " (" + in_permit.ReviewedBy + ")";
            }

            string body = "<h3>Permit " + in_event.EventType + " Request from TPO</h3>";
            body += "<p><b>Permit</b>: <a href='"+PermitURL+in_permit.Id+"'>"+in_permit.PermitNumber+ "</a></p>";
            body += "<p><b>Project Name</b>: " + in_permit.ProjectName + "</p>";
            body += "<p><b>Reviewed By</b>: " + in_permit.ReviewedBy + "</p>";
            body += "<p><b>Request Date</b>: " + in_event.RequestDate + "</p>";
            
            if(in_event.Comments != null)
                body += "<hr/><p><b>Comments</b>: "+in_event.Comments;

            body += "<hr/>Reference Documents:";

            try
            {
                EmailHelper.SendEmail(recipient, "noreply@ctuir.org", subject, body);
                logger.Debug("Sent an email to " + recipient); //TODO: save in the notification log
            }
            catch (Exception e)
            {
                logger.Debug("Well that didn't work out: " + e.Message);
                logger.Debug(e.InnerException);
            }

        }

        private static string getEmailContactForEvent(PermitEvent in_event){
            return "kenburcham@ctuir.org";
        }


    }
}