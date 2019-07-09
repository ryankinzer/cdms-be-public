using Newtonsoft.Json.Linq;
using NLog;
using services.Models.Data;
using System;
using System.Collections.Generic;

namespace services.Resources
{
    public class PermitEventNotifier
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();

        public static void notify(Permit in_permit, PermitEvent in_event, dynamic in_json){

            string PermitURL = System.Configuration.ConfigurationManager.AppSettings["EmailPermitURL"];
            string PermitProjectId = System.Configuration.ConfigurationManager.AppSettings["PermitProjectId"];

            List<string> recipients = PermitRouteHelper.getEmailForRoute(in_event.EventType, in_event.ItemType);

            string subject = in_event.EventType + " Request from TPO for " + in_event.ItemType;
            if(in_permit.ReviewedBy != null){
                subject += " (" + in_permit.ReviewedBy + ")";
            }

            string body = "<h3>Permit " + in_event.EventType + " Request from CTUIR Planning Office</h3>";

            if (in_event.EventType == "Review")
            {
                body += "<p><b>Permit</b>: <a href='" + PermitURL + in_permit.Id + "'>" + in_permit.PermitNumber + "</a></p>";
                body += "<p><b>Project Name</b>: " + in_permit.ProjectName + "</p>";
                body += "<p><b>TPO Reviewer</b>: " + in_permit.ReviewedBy + "</p>";
                body += "<p><b>Request Date</b>: " + in_event.RequestDate + "</p>";
            }
            
            if(in_event.EventType == "Inspection"){
                body += "<p><b>Permit Number</b>: " + in_permit.PermitNumber + "</p>";
                body += "<p><b>Site Address</b>: " + in_permit.SiteAddress + " " + in_permit.SiteCity + "</p>";
                body += "<p><b>Project Name</b>: " + in_permit.ProjectName + "</p>";
                body += "<p><b>Type of Inspection</b>: " + in_event.Reference + "</p>";
                body += "<p><b>Date of Inspection Desired</b>: " + ((DateTime)in_event.RequestDate).ToShortDateString() + "</p>";

                var preferred_time = "Any";
                if (in_json.PreferredTime["PM"] is JToken)
                    if (in_json.PreferredTime.PM == true)
                        preferred_time = "PM";
                    else if (in_json.PreferredTime["AM"] is JToken)
                        if (in_json.PreferredTime.AM == true)
                            preferred_time = "AM";

                body += "<p><b>Preferred Time</b>: " + preferred_time + "</p>";

                List<string> inspection_requested = new List<string>();
                
                if (in_json.InspectorsContact["Structural"] is JToken )
                    if(in_json.InspectorsContact.Structural == true)
                        inspection_requested.Add("Structural/Mechanical");
                if (in_json.InspectorsContact["Plumbing"] is JToken)
                    if(in_json.InspectorsContact.Plumbing == true)
                        inspection_requested.Add("Plumbing");
                if (in_json.InspectorsContact["Electrical"] is JToken)
                    if(in_json.InspectorsContact.Electrical == true)
                        inspection_requested.Add("Electrical");

                body += "<p><b>Inspection Requested</b>: " + string.Join(", ",inspection_requested) + "</p>";
                
                body += "<p><b>Contact</b>: " + in_json.ContactNumber + "</p>";
                body += "<p><b>Sent By</b>: " + in_permit.ReviewedBy + "</p>";
                body += "<p><b>Sent Date</b>: " + in_event.EventDate.ToShortDateString() + "</p>";

            }

            if(in_event.Comments != null)
                body += "<hr/><p><b>Comments</b>: "+in_event.Comments;

            if (in_event.EventType == "Review")
            {
                body += "<hr/>Reference Documents:";   
            }

            body += "<br/><br/> -- Please contact CTUIR Planning Office at 541-276-3099 with any questions.<br/>Thank you!";

            string attachment = null;

            //if it is an inspection, attach the body as an attachment and let the body just be an introduction
            if(in_event.EventType == "Inspection")
            {
                attachment = body;
                body = "Inspection requested. Please contact CTUIR Planning Office at 541-276-3099 with any questions.<br/>Thank you!";
            }


            try
            {
                EmailHelper.SendEmail( recipients, "kenburcham@ctuir.org", subject, body, attachment);

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