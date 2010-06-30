using Machine.Specifications;
using Moq;
using Itt = Moq.It;
using It = Machine.Specifications.It;

namespace Demo
{
    [Subject("Mass Mailer")]
    public class Mailing_A_Message_To_List_Of_Users
    {
        static Mock<IMailService> serviceMock;
        static MassMailer Mailer;

        Establish context = () =>
        {
            serviceMock = new Mock<IMailService>();

            Mailer = new MassMailer(serviceMock.Object);
        };

        Because of = () =>
        {
            Mailer.SendMessages(new Message(), "bill@microsoft.com", "steve@apple.com");
        };

        It should_send_messages_to_each_address = () =>
        {
            serviceMock.Verify(
                svc => svc.Send(Itt.IsAny<Message>(), Itt.IsAny<string>()),
                Times.Exactly(2));
        };

        /* more tests */
    }

    public class MassMailer
    {
        readonly IMailService _mailService;

        public MassMailer(IMailService mailService)
        {
            _mailService = mailService;
        }

        public void SendMessages(Message message, params string[] addresses)
        {
            addresses.Each(addr => _mailService.Send(message, addr));
        }
    }
}
