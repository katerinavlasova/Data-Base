using System;
using System.Xml;
using System.Xml.Schema;

public class XmlSchemaSetExample
{
    public static void Main()
    {
        XmlReaderSettings Settings = new XmlReaderSettings();
        Settings.Schemas.Add("", "C:/db/lab_05/3.xsd");
        Settings.ValidationType = ValidationType.Schema;
        Settings.ValidationEventHandler += new ValidationEventHandler(settingsValidationEventHandler);

        XmlReader schoools = XmlReader.Create("C:/db/lab_05/schools_bad.xml", Settings);

        while (schoools.Read()) { }
        Console.Write("Validation end!\n");
        System.Threading.Thread.Sleep(10000);
    }

    static void settingsValidationEventHandler(object sender, ValidationEventArgs e)
    {
        if (e.Severity == XmlSeverityType.Warning)
        {
            Console.Write("WARNING: ");
            Console.WriteLine(e.Message);
            System.Threading.Thread.Sleep(1000);
        }
        else if (e.Severity == XmlSeverityType.Error)
        {
            Console.Write("ERROR: ");
            Console.WriteLine(e.Message);
            System.Threading.Thread.Sleep(1000);
        }
    }
}