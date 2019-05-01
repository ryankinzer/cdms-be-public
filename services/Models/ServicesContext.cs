using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Reflection;
using System;
using System.Linq;
using System.Collections;
using NLog;
using System.Diagnostics;
using services.Resources.Attributes;

namespace services.Models
{
    public class ServicesContext : DbContext
    {
        // You can add custom code to this file. Changes will not be overwritten.
        // 
        // If you want Entity Framework to drop and regenerate your database
        // automatically whenever you change your model schema, add the following
        // code to the Application_Start method in your Global.asax file.
        // Note: this will destroy and re-create your database with every model change.
        // 
        // System.Data.Entity.Database.SetInitializer(new System.Data.Entity.DropCreateDatabaseIfModelChanges<services.Models.ServicesContext>());

        public ServicesContext() : base("name=ServicesContext")
        {
            this.Configuration.LazyLoadingEnabled = true;
            this.Configuration.ProxyCreationEnabled = true;
            Database.SetInitializer<ServicesContext>(null); //turn off the model comparator
        }

        private static Logger logger = LogManager.GetCurrentClassLogger();

        /*    
             * There are three types of entities in CDMS:
             * 1) CDMS System Entities - system-level classes like:
             *      - projects
             *      - datasets
             *      - locations
             *      - activities
             *      
             *      These are defined in this file statically and are in the namespace: services.Models
             *      
             *  2) CDMS "Core" Datasets - datasets that are dynamically loaded but
             *     are shared with everyone. These are the fisheries datasets like:
             *      - Adult Weir
             *      - Screw Trap
             *      - StreamNet_NOSA
             *      
             *  3) CDMS "Private" Datasets - datasets that are dynamically loaded but the code for these 
             *     are not shared with everyone. These are datasets that tribes create
             *     that they want to have only within their organization.
             *     
             *     Both type 2 and type 3 are loaded dynamically from the namespace: services.Models.Data
             *     These are loaded at runtime during the OnModelCreating method below.
             *     
             *  
         */
        
        //cdms system entities
        public DbSet<Project> Projects { get; set; }
        public DbSet<MetadataValue> MetadataValue { get; set; }
        public DbSet<AuditJournal> AuditJournal { get; set; }
        public DbSet<User> User { get; set; }
        public DbSet<Location> Location { get; set; }
        public DbSet<LocationType> LocationType { get; set; }
        public DbSet<MetadataEntity> MetadataEntity { get; set; }
        public DbSet<MetadataProperty> MetadataProperty { get; set; }
        public DbSet<Organization> Organization { get; set; }
        public DbSet<ProjectType> ProjectType { get; set; }
        public DbSet<SdeFeatureClass> SdeFeatureClass { get; set; }
        public DbSet<UserPreference> UserPreference { get; set; }
        public DbSet<File> Files { get; set; }
        public DbSet<FileType> FileTypes { get; set; }
        public DbSet<Department> Departments { get; set; }
        public DbSet<PitagisData> PitagisData { get; set; }

        public DbSet<Dataset> Datasets { get; set; }
        public DbSet<Datastore> Datastores { get; set; }
        public DbSet<DatasetField> DatasetFields { get; set; }
        public DbSet<Field> Fields { get; set; }
        //public DbSet<FieldCategory> FieldCategories { get; set; }
        public DbSet<FieldRole> FieldRoles { get; set; }
        public DbSet<Instrument> Instruments { get; set; }

        public DbSet<InstrumentType> InstrumentType { get; set; }
        public DbSet<InstrumentAccuracyCheck> AccuracyChecks { get; set; }
        public DbSet<Source> Sources { get; set; }
        public DbSet<QAStatus> QAStatuses { get; set; }
        public DbSet<WaterBody> WaterBodies { get; set; }

        public DbSet<Activity> Activities { get; set; }
        public DbSet<ActivityQA> ActivityQAs { get; set; }
        public DbSet<ActivityType> ActivityTypes { get; set; }

        public DbSet<LookupTable> LookupTables { get; set; }

        //lookup tables
        public DbSet<Fisherman> Fishermen { get; set; }
        public DbSet<Collaborator> Collaborators { get; set; }
        public DbSet<Funding> Funding { get; set; }
        public DbSet<County> Counties { get; set; }
        public DbSet<Seasons> Seasons { get; set; }

        //get the dbset by name
        public DbSet GetDbSet(string entityName, string entityNamespace = "services.Models.Data")
        {
            return this.Set(GetTypeFor(entityName, entityNamespace));
        }

        //get the type for an entity by name
        public System.Type GetTypeFor(string entityName, string entityNamespace = "services.Models.Data")
        {
            //we have to map "fishermen" to "fisherman" because it doesn't follow the convention
            if (entityName == "Fishermen")
                entityName = "Fisherman";

            return GetObjectFor(entityName, entityNamespace).GetType();
        }

        //get an entity object by name
        public dynamic GetObjectFor(string entityName, string entityNamespace = "services.Models.Data")
        {
            var datasource = entityNamespace + "." + entityName;
            var obj = System.Activator.CreateInstance("services", datasource).Unwrap();
            return obj;
        }

        //called during the startup phase
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            //Load all "services.Models.Data.*" entities that are DataDetail, DataHeader or DatasetStandalone types.
            IEnumerable typelist = GetTypesInNamespace(Assembly.GetExecutingAssembly(), "services.Models.Data"); //NOTE: we only hot-load header/detail type dataset entities
            foreach (Type type in typelist)
            {
                //Debug.WriteLine("Found something: " + type.Name);
                if (type.IsSubclassOf(typeof(Data.DataDetail)) ||
                    type.IsSubclassOf(typeof(Data.DataHeader)) ||
                    type.IsSubclassOf(typeof(Data.Subproject)) ||
                    type.IsSubclassOf(typeof(Data.DataEntity)))
                {
                   //Debug.WriteLine(" It is a dataset... attaching entity: " + type.Name);

                    MethodInfo method = modelBuilder.GetType().GetMethod("Entity");
                    method = method.MakeGenericMethod(new Type[] { type });
                    method.Invoke(modelBuilder, null);
                }
            }

            modelBuilder.Conventions.Add(new DecimalPrecisionAttributeConvention());
            modelBuilder.Conventions.Remove<OneToManyCascadeDeleteConvention>();

        }

        public static ServicesContext Current
        {
            get
            {
                if (System.Web.HttpContext.Current != null) //hey because sometimes it is! TODO
                    return System.Web.HttpContext.Current.Items["_EntityContext"] as ServicesContext;
                else
                    return new ServicesContext();
            }

        }

        public static ServicesContext RestartCurrent
        {
            get
            {
                //dispose of the existing one if it exists.
                var entityContext = System.Web.HttpContext.Current.Items["_EntityContext"] as ServicesContext;
                if (entityContext != null)
                    entityContext.Dispose();

                //start a new one.
                System.Web.HttpContext.Current.Items["_EntityContext"] = new ServicesContext(); //create a whole new one...
                return System.Web.HttpContext.Current.Items["_EntityContext"] as ServicesContext;
            }

        }

        //get the types in this namespace of an assembly
        private IEnumerable GetTypesInNamespace(Assembly assembly, string nameSpace)
        {
            return assembly.GetTypes()
                .Where(t => String.Equals(t.Namespace, nameSpace, StringComparison.Ordinal));
        }

    }
}
