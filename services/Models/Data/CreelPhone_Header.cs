using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class CreelPhone_Header : DataHeader
    {
        //public DateTime? ContactDate { get; set; }
        public int FishermanId { get; set; }
        public string Fished { get; set; }
        public string InterviewComments { get; set; }
        public int Season { get; set; }
    }
}