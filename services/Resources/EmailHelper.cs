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

            MailMessage message = new MailMessage(in_sender, in_recipient, in_subject, in_message);

            message.IsBodyHtml = true;

            SmtpClient client = new SmtpClient(EmailServer);
            //client.Credentials = CredentialCache.DefaultNetworkCredentials;

            client.Send(message); //throws an exception if it fails... just let it escalate

            return true;

        }
    }
}