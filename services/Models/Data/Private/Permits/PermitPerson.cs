using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;


namespace services.ExtensionMethods
{
    public static class PermitPersonExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<PermitPerson> PermitPerson(this ServicesContext ctx)
        {
            return ctx.GetDbSet("PermitPerson").Cast<PermitPerson>();
        }
    }
}

namespace services.Models.Data
{
    public class PermitPerson : DataEntity
    {
        public int Id { get; set; }
        public string Organization { get; set; }
        public string Prefix{ get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
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
        public string HomePhone { get; set; }
        public string WorkPhone { get; set; }
        public string CellPhone { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public DateTime? LastUpdated { get; set; }
        public string UpdatedBy { get; set; }
        public bool Inactive { get; set; } 
    }
}