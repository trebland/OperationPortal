using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using MailKit.Net.Smtp;
using MailKit;
using MimeKit;
using MailKit.Security;
using API.Models;

namespace API.Helpers
{
    public class EmailHelpers
    {
        
        public static async Task SendEmail(string to, string subject, string text, EmailConfig config)
        {
            if (!UserHelpers.IsValidEmail(to))
            {
                throw new Exception("Invalid email address");
            }

            var message = new MimeMessage();

            message.From.Add(new MailboxAddress(config.Name, config.Address));
            message.To.Add(new MailboxAddress(to));
            message.Subject = subject;
            message.Body = new TextPart(MimeKit.Text.TextFormat.Plain)
            {
                Text = text
            };

            using (var smtp = new SmtpClient())
            {
                smtp.ServerCertificateValidationCallback = (s, c, h, e) => true;

                await smtp.ConnectAsync(config.Server, 587, SecureSocketOptions.StartTls);
                await smtp.AuthenticateAsync(config.UserName, config.Password);
                await smtp.SendAsync(message);
                await smtp.DisconnectAsync(true);
            }
        }

    }
}
