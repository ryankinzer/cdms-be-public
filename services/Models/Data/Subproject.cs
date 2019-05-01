using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/**
 * Used for defining an entity that isn't a header/detail
 */ 

namespace services.Models.Data
{
    public abstract class Subproject
    {
        public int Id { get; set; }
        public int ByUserId { get; set; }
        public DateTime EffDt { get; set; }
    }
}