namespace Demo
{
    public interface IMailService
    {
        void Send(Message message, string address);
        bool IsConnected { get; set; }
    }
}