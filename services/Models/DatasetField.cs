using Newtonsoft.Json;
using System;

namespace services.Models
{
    /*
     * association of a field to a dataset
     * 
     * a single dataset will have a set of fields, a subset of which might be associated
     * with a header table and a subset associated with a detail table.  The Field Role
     * determines how the field is being used in the dataset and the DbTable determines
     * where the data for the field is actually stored.
     */

    public class DatasetField
    {
        public int Id { get; set; }
        public int DatasetId { get; set; }
        public int FieldId { get; set; }
        public int FieldRoleId { get; set; }
        public DateTime CreateDateTime { get; set; }
        public string Label { get; set; }
        public string DbColumnName { get; set; }
        public string ControlType { get; set; }
        public string Validation { get; set; }
        public string Rule { get; set; }
        public int? SourceId { get; set; }
        public int? InstrumentId { get; set; }
        public int? OrderIndex { get; set; }
        public int? ColumnIndex { get; set; }

        public virtual Field Field { get; set; }

        [JsonIgnore]
        public virtual FieldRole FieldRole { get; set; }

        [JsonIgnore]
        public virtual Source Source { get; set; }

        [JsonIgnore]
        public virtual Instrument Instrument { get; set; }
    }
}