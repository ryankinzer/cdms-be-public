using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using services.Resources;

namespace services.Models
{
    public class Field
    {
        private string _possibleValues;

        public int Id { get; set; }
        //public int FieldCategoryId { get; set; }
        public int DatastoreId { get; set; }
        public int FieldRoleId { get; set; }
        public string TechnicalName { get; set; }
        public string DbColumnName { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Units { get; set; }
        public string DataSource { get; set; } //SQL query used by lookup and multilookup type fields to populate the possiblevalues auto-magically
                                               // needs to have an Id and Label, e.g.: "select Id, fullname as Label from fishermen"
        public string PossibleValues
        {
            get
            {
                if (DataSource != null)
                {
                    return LookupFieldHelper.getPossibleValues(DataSource);
                }
                
                return _possibleValues;
            }

            set
            {
                if (DataSource == null)
                    _possibleValues = value;
                //otherwise -- we won't set it... we don't want to set possible values
                //  since they are populated from a query.
            }
        }
        public string Validation { get; set; }
        public string Rule { get; set; }
        public string DataType { get; set; }
        public string ControlType { get; set; }

        [JsonIgnore]
        public virtual FieldRole FieldRole { get; set; }

        [JsonIgnore]
        public virtual Datastore Datastore { get; set; }

    }

/*
    public class FieldCategory {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }

    }
*/


    //FieldRole == Header, Detail, Summary, Statistic, ...
    public class FieldRole {

        public const int HEADER = 1;
        public const int DETAIL = 2;

        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }


    public class Source
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }


}