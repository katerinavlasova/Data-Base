using System;
using System.Xml;
using System.Xml.Schema;

public class XmlSchemaSetExample
{
    public static void Main()
    {
        XmlReaderSettings Settings = new XmlReaderSettings();
        Settings.Schemas.Add("", "3.xsd");
        Settings.ValidationType = ValidationType.Schema;
        Settings.ValidationEventHandler += new ValidationEventHandler(settingsValidationEventHandler);

        XmlReader schoools = XmlReader.Create("schools.xml", Settings);

        while (schoools.Read()) { }
        Console.Write("Validation end!\n");
    }

    static void settingsValidationEventHandler(object sender, ValidationEventArgs e)
    {
        if (e.Severity == XmlSeverityType.Warning)
        {
            Console.Write("WARNING: ");
            Console.WriteLine(e.Message);
        }
        else if (e.Severity == XmlSeverityType.Error)
        {
            Console.Write("ERROR: ");
            Console.WriteLine(e.Message);
        }
    }
}