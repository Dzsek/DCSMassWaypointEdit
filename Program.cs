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
            try
            {
                if (args.Length < 1)
                {
                    Console.WriteLine("No miz file specified");
                    Console.ReadLine();
                    Environment.Exit(0);
                }

                Console.WriteLine(args[0]);
                var zip = ZipFile.Open(args[0], ZipArchiveMode.Update);
                var mission = zip.Entries.FirstOrDefault(x => x.Name == "mission");
                mission.ExtractToFile("mission", true);

                var process = new Process();
                process.StartInfo.FileName = "lua.exe";
                process.StartInfo.Arguments = "waypoints.lua mission mission_out";
                process.Start();

                process.WaitForExit();

                if (File.Exists("mission_out"))
                {
                    mission.Delete();
                    zip.CreateEntryFromFile("mission_out", "mission");
                    zip.Dispose();

                    Console.WriteLine();
                    Console.WriteLine("Done");
                }

                File.Delete("mission");
                File.Delete("mission_out");
                Console.ReadLine();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.ReadLine();
            }
        }
    }
}
