using services.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;


namespace services.Resources
{
    public class EmailHelper
    {
        public static Boolean SendEmail(string in_recipient, string in_sender, string in_subject, string in_message) {

            string EmailServer = System.Configuration.ConfigurationManager.AppSettings["EmailServer"];
            string EmailLogOnly = System.Configuration.ConfigurationManager.AppSettings["EmailServer_LogOnly"];

            MailMessage message = new MailMessage(in_sender, in_recipient, in_subject, in_message);

            message.IsBodyHtml = true;

            SmtpClient client = new SmtpClient(EmailServer);
            //client.Credentials = CredentialCache.DefaultNetworkCredentials;

            var db = ServicesContext.Current;

            NotificationLog log = buildLog(message);

            try
            {
                if (EmailLogOnly == "False")
                {
                    log.Result = "Success";
                    client.Send(message);
                }
                else
                {
                    log.Result = "Log Only";
                }
                
                db.NotificationLog.Add(log);
                db.SaveChanges();
            }
            catch(Exception e){
                log.Result = "Failed: " + e.Message;
                db.NotificationLog.Add(log);
                db.SaveChanges();
                throw e; //rethrow
            }

            return true; //otherwise the caller will get an exception

        }

        private static NotificationLog buildLog(MailMessage message){
            NotificationLog log = new NotificationLog();

            log.Sender = message.From.ToString();
            log.Recipient = message.To.ToString();
            log.Subject = message.Subject;
            log.Body = message.Body;
            log.SentDate = DateTime.Now;

            return log;
        }

    }
}