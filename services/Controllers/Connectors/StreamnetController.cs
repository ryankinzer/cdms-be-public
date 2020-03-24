using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Web.WebPages;

namespace services.Controllers
{
    public class StreamnetController : CDMSController
    {
        // GET /api/v1/streamnet/synctostreamnet
        [HttpGet]
        public List<string> SyncToStreamNet()
        {
            logger.Debug("Inside SyncToStreamNet...");
            var pathToStreamNetSyncScript = System.Configuration.ConfigurationManager.AppSettings["PathToStreamNetSyncScript"];

            if (pathToStreamNetSyncScript.IsEmpty())
                return new List<string>() { "Need to specify path to StreamNet sync script in your web.config!" };

            if (System.IO.File.Exists(pathToStreamNetSyncScript))
                logger.Debug("The script file exists...");
            else
                logger.Debug("The script file does not exist or is inaccessible...");

            var proc = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "python.exe",
                    Arguments = pathToStreamNetSyncScript,
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                }
            };

            string strPath = Environment.GetEnvironmentVariable("Path");
            if (strPath.IndexOf("python") < 0)
            {
                logger.Debug("The system environment variable Path does not include python...correcting.");
                strPath = strPath + ";C:\\python35\\Scripts\\;C:\\python35\\";
                Environment.SetEnvironmentVariable("Path", strPath);
            }

            string strWebException = "";
            // Note:  The following url works to verify StreamNet is up and running, but it is not the actual url we will use to do the update.
            HttpWebRequest thisRequest = (HttpWebRequest)WebRequest.Create("https://api.streamnet.org/api/v1/users?email=ColetteCoiner@ctuir.org&password=8JnGDynP");
            thisRequest.Timeout = 5000;
            // If we use this the line below, it does not retrieve enough or the right stuff, so throws an exception.
            //thisRequest.Method = "HEAD"; // We do not want to actually download anything right now.
            try
            {
                using (HttpWebResponse thisResponse = (HttpWebResponse)thisRequest.GetResponse())
                {
                    //logger.Debug("thisResponse code = " + (int)thisResponse.StatusCode);
                    logger.Debug("Connected to StreamNet OK...");
                }
            }
            catch (WebException)
            {
                logger.Debug("Had a problem creating the connection to the website api.streamnet.org");
                strWebException = "Had a problem creating the connection to the website api.streamnet.org";
            }

            logger.Debug("About to start Python process...");
            proc.Start();
            logger.Debug("Python process started...");

            var outputLines = new List<string>();


            while (!proc.StandardOutput.EndOfStream)
                outputLines.Add(proc.StandardOutput.ReadLine());

            while (!proc.StandardError.EndOfStream)
            {
                outputLines.Add(proc.StandardError.ReadLine());
            }
            if (strWebException.Length > 0)
                outputLines.Add(strWebException);

            logger.Debug("Finished sync process.  Result will be displayed on screen...");

            return outputLines;
        }

    }
}
