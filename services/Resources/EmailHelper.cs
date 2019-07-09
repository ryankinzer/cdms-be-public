﻿using services.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Web;


namespace services.Resources
{
    public class EmailHelper
    {
        public static Boolean SendEmail(List<string> in_recipients, string in_sender, string in_subject, string in_message)
        {
            return EmailHelper.SendEmail(in_recipients, in_sender, in_subject, in_message, null);
        }

        public static Boolean SendEmail(List<string> in_recipients, string in_sender, string in_subject, string in_message, string in_attachment) {

            string EmailServer = System.Configuration.ConfigurationManager.AppSettings["EmailServer"];
            string EmailLogOnly = System.Configuration.ConfigurationManager.AppSettings["EmailServer_LogOnly"];

            MailMessage message = new MailMessage();
            message.From = new MailAddress(in_sender);
            message.Subject = in_subject;
            message.Body = in_message;
            in_recipients.ForEach(delegate (string recipient) {
                message.To.Add(new MailAddress(recipient));
            });
            //message.CC.Add("kenburcham@ctuir.org");

            message.IsBodyHtml = true;

            SmtpClient client = new SmtpClient(EmailServer);
            //client.Credentials = CredentialCache.DefaultNetworkCredentials;

            var db = ServicesContext.Current;

            NotificationLog log = buildLog(message);

            //handle attachment if there is one
            MemoryStream ms = new MemoryStream();

            if (in_attachment != null)
            {
                Byte[] pdf_doc = null;
                var pdf = TheArtOfDev.HtmlRenderer.PdfSharp.PdfGenerator.GeneratePdf(in_attachment, PdfSharp.PageSize.Letter);
                pdf.Save(ms);
                pdf_doc = ms.ToArray();

                Attachment attachment = new Attachment(new MemoryStream(pdf_doc), "attachment.pdf");

                message.Attachments.Add(attachment);

            }

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
            catch (Exception e)
            {
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

        internal static Byte[] PdfSharpConvert(String html)
        {
            Byte[] res = null;
            using (MemoryStream ms = new MemoryStream())
            {
                var pdf = TheArtOfDev.HtmlRenderer.PdfSharp.PdfGenerator.GeneratePdf(html, PdfSharp.PageSize.Letter);
                pdf.Save(ms);
                res = ms.ToArray();
            }
            return res;
        }

    }
}