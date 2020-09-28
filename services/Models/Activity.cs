using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace services.Models
{
    public class Activity
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int DatasetId { get; set; }
        public int SourceId { get; set; }
        public int LocationId { get; set; }
        public int UserId { get; set; }
        public int ActivityTypeId { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime ActivityDate { get; set; } //date of actual activity event
        public int? InstrumentId { get; set; }
        public int? LaboratoryId { get; set; }
        public int? AccuracyCheckId { get; set; } //applied to this data
        public int? PostAccuracyCheckId { get; set; } //if applicable.
        public string Timezone { get; set; }  //timezone offset from UTC for this activity (if applicable) in ms

        public virtual User User { get; set; }

        [JsonIgnore]
        public virtual Dataset Dataset { get; set; }

        public virtual ActivityType ActivityType { get; set; }
        public virtual Source Source { get; set; }
        public virtual Location Location { get; set; }
        //public virtual Laboratory Laboratory { get; set; }
        public virtual InstrumentAccuracyCheck AccuracyCheck { get; set; }
        public virtual InstrumentAccuracyCheck PostAccuracyCheck { get; set; }
        public virtual Instrument Instrument { get; set; }

        
        [NotMapped]
        public ActivityQA ActivityQAStatus { 
            get
            {
                var db = ServicesContext.Current;

                var q = from aq in db.ActivityQAs
                        where aq.ActivityId == this.Id
                        orderby aq.EffDt descending
                        select aq;

                return q.FirstOrDefault();
            } 
        }

        //activity level duplicate checking
        internal bool isDuplicate()
        {
            var db = ServicesContext.Current;

            var q = from a in db.Activities
                    where a.ActivityDate.Equals(this.ActivityDate)
                    where a.DatasetId.Equals(this.DatasetId)
                    where a.SourceId.Equals(this.SourceId)
                    where a.ActivityTypeId.Equals(this.ActivityTypeId)
                    select a;

            return q.Any();
        }
    }

    public class ActivityQA
    {
        public int Id { get; set; }
        public int ActivityId { get; set; } //rowid for effdt
        public int QAStatusId { get; set; }
        public int UserId { get; set; }
        public DateTime EffDt { get; set; }
        public string QAComments { get; set; }
        public string QAStatusName { get; set; }
        public string QAStatusDescription { get; set; }

        [JsonIgnore]
        [NotMapped]
        public virtual Activity Activity { get; set; }
        public virtual QAStatus QAStatus { get; set; }
        public virtual User User { get; set; }
    }

    public class ActivityType
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
    

}