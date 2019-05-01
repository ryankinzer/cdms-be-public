using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;


namespace services.ExtensionMethods
{
    public static class LeaseOperatorExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<LeaseOperator> LeaseOperator (this ServicesContext ctx)
        {
            return ctx.GetDbSet("LeaseOperator").Cast<LeaseOperator>();
        }
    }
}

namespace services.Models.Data
{
    public class LeaseOperator : DataEntity
    {
        public int Id { get; set; }
        public string Organization { get; set; }
        public string Prefix{ get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Suffix { get; set; }
        public string MailingAddress1 { get; set; }
        public string MailingAddress2 { get; set; }
        public string MailingCity { get; set; }
        public string MailingState { get; set; }
        public string MailingZip { get; set; }
        public string PhysicalAddress1 { get; set; }
        public string PhysicalAddress2 { get; set; }
        public string PhysicalCity { get; set; }
        public string PhysicalState { get; set; }
        public string PhysicalZip { get; set; }
        public Boolean? IsMailingDifferent { get; set; }
        public string Phone { get; set; }
        public string Cell { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public DateTime? LastUpdated { get; set; }
        public string UpdatedBy { get; set; }
        public bool Inactive { get; set; } 
    }
}