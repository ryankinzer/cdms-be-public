using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace services.Models
{
    public class Characteristics
    {
        public const int ACTIVE_STATUSID = 0;  // Active
        public const int INACTIVE_STATUSID = 1;  // Inactive

        public int Id { get; set; }
        public string CharacteristicName { get; set; }
        public int CharacteristicActive { get; set; }

        public Characteristics()
        {
            CharacteristicActive = ACTIVE_STATUSID;
        }
    }
}