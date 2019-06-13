using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class CrppContracts_Header: DataHeader
    {
        //public string CrppPersonnel { get; set; }
        //public int? ActivityTypeId { get; set; }
        //public string Agency { get; set; }
        public string ProjectProponent { get; set; }
        //public string PermitNumber { get; set; }
        //public DateTime? DateReceived { get; set; }
        //public DateTime? DateOfAction { get; set; }
        //public string ActionTaken { get; set; }
        //public string ActivityNotes { get; set; }
        //public string AttachedDocument { get; set; }

        public string ProjectLead { get; set; }
        public string CostCenter { get; set; }
        public string ProjectName { get; set; }
        public string Client { get; set; }
        public string AgreeNumb { get; set; }
        public DateTime? DateExec { get; set; }
        public DateTime? DraftDue { get; set; }
        public DateTime? FinalDue { get; set; }
        public DateTime? ContractEnd { get; set; }
        public DateTime? ModExtDate { get; set; }
        public string DocumentLink { get; set; }
        public string ActivityComments { get; set; }

        public Single? AwardAmount { get; set; }
        public DateTime? FinalReportSubmitted { get; set; }
        public string OnReservation { get; set; }
    }
}