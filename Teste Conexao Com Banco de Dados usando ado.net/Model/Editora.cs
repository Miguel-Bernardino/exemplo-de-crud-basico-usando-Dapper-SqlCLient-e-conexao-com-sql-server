using System;
using System.Collections.Generic;
using System.Text;

namespace TesteConexaoDB.Model
{
    public class Editora
    {
        public int? id_editora { get; set; }
        public string descrição { get; set; } = "";
        public string endereço { get; set; } = "N/A";
    }
}
