using Newtonsoft.Json.Linq;
using NLog;
using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Linq;

/**
 * Sends a receipt to the TPO planner who initiated the event
*/

namespace services.Resources
{
    public class PermitReceiptNotifier
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();

        public static void notify(Permit in_permit, PermitEvent in_event){

            string PermitURL = System.Configuration.ConfigurationManager.AppSettings["EmailPermitURL"];
            string PermitConfirmRecipient = System.Configuration.ConfigurationManager.AppSettings["EmailPermitConfirmRecipient"];
            string PermitProjectId = System.Configuration.ConfigurationManager.AppSettings["PermitProjectId"];

            List<string> recipients = new List<string> { PermitConfirmRecipient }; 

            string subject = in_event.EventType + " Confirmation Receipt for " + in_event.ItemType;
            if(in_permit.ReviewedBy != null){
                subject += " (" + in_permit.ReviewedBy + ")";
            }

            string body = "<h3>Confirmation Receipt</h3>";

                body += "<p><b>Permit Number</b>: " + in_permit.PermitNumber + "</p>";
                body += "<p><b>Project Name</b>: " + in_permit.ProjectName + "</p>";
                body += "<p><b>TPO Reviewer</b>: " + in_permit.ReviewedBy + "</p>";
                body += "<p><b>Request Date</b>: " + in_event.RequestDate + "</p>";
                body += "<p><b>Site Address</b>: " + in_permit.SiteAddress + " " + in_permit.SiteCity + "</p>";
                
                body += "<p><b>Item Type</b>: " + in_event.ItemType + "</p>";
                body += "<p><b>Event Type</b>: " + in_event.EventType + "</p>";
            //body += "<p><b>Permit</b>: <a href='" + PermitURL + in_permit.Id + "'>" + in_permit.PermitNumber + "</a></p>"; //TODO: Phase 2 will provide a link to reviewers

            body += "<br/><br/>Click to: <a href='"+ PermitURL + in_permit.Id + "'> Open permit record</a>";

            string attachment = null;

            try
            {
                EmailHelper.SendEmail( recipients, "tpo@ctuir.org", subject, body, attachment, "PermitConfirm");

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