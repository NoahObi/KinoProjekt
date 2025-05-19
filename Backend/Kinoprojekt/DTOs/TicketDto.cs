using Database;

namespace Kinoprojekt.DTOs
{
    public partial class TicketDto
    {
        public int VorstellungID { get; set; }
        public int KundeID { get; set; }
        public string Sitzplatz { get; set; }
        public int PreisID { get; set; }
        public int ZahlungsID { get; set; }
        public int? ReservierungID { get; set; }
        public List<SnackMengeDto> SnackMengen { get; set; }
    }
}
