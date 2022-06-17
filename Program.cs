using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace MassWaypointEdit
{
    class Program
    {
        static void Main(string[] args)
        {
            if(args.Length < 1)
            {
                Console.WriteLine("No miz file specified");
                Environment.Exit(0);
            }

            Console.WriteLine(args[0]);
            var zip = ZipFile.Open(args[0], ZipArchiveMode.Update);
            var mission = zip.Entries.FirstOrDefault(x => x.Name == "mission");
            mission.ExtractToFile("mission", true);

            var process = new Process();
            process.StartInfo.FileName="lua.exe";
            process.StartInfo.Arguments = "waypoints.lua";
            process.Start();

            process.WaitForExit();

            if(File.Exists("mission2"))
            {
                mission.Delete();
                zip.CreateEntryFromFile("mission2", "mission");
                zip.Dispose();

                Console.WriteLine();
                Console.WriteLine("Done");
            }

            File.Delete("mission");
            File.Delete("mission2");
            Console.ReadLine();
        }
    }
}
