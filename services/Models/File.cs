using System;
using Newtonsoft.Json;

namespace services.Models
{
    public class File
    {

        public const int SHARINGLEVEL_PRIVATE = 1;
        public const int SHARINGLEVEL_GROUPREAD = 2;
        public const int SHARINGLEVEL_PUBLICREAD = 3;
        public const int SHARINGLEVEL_GROUPWRITE = 4;
        public const int SHARINGLEVEL_PUBLICWRITE = 5;

        public int Id { get; set; }
        public int ProjectId { get; set; }
        public int UserId { get; set; }
        public string Name { get; set; } //myfile.pdf
        public string Title { get; set; } //My File
        public string Description { get; set; } //This is my file.
        public DateTime UploadDate { get; set; }
        public string Size { get; set; }
        public string Link { get; set; } // /repo/files/myfile.pdf
        public int FileTypeId { get; set; }
        public int? Subproject_CrppId { get; set; }
        public int? FeatureImage { get; set; }
        public int? DatasetId { get; set; }
        public int SharingLevel { get; set; }
        public int ItemId { get; set; }

        [JsonIgnore]
        public virtual Project Project { get; set; }
        public virtual User User { get; set; }
        public virtual FileType FileType { get; set; }

        public File()
        {
            //milliseconds causes us trouble when converting to javascript date later.  so we just want seconds.
            var now = DateTime.UtcNow;
            UploadDate = new DateTime(now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second, DateTimeKind.Utc);
        }

    }
}