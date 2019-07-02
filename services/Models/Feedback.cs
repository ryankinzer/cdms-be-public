using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models
{
    public class Feedback
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public string Module { get; set; }
        public string SubmitterName { get; set; }
        public DateTime SubmitDate { get; set; }
        public string ResponseMessage { get; set; }
        public DateTime? ResponseDate { get; set; }
        public string Status { get; set; }

    }
}   