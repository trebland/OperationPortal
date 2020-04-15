import React, { Component } from 'react'
import { Redirect } from 'react-router-dom'
import { Button } from 'react-bootstrap'


export class PrivacyPolicy extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return <Redirect to={{
                pathname: '/',
                loggedin: false
            }}/>
        }
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <div style={styling.outderdiv}>
                    {/* <h1 style={{textAlign: 'center'}}>Privacy Policy of Orlando Children’s Church</h1> */}
                    <center>
                        <h2>Privacy Policy For Mobile Application</h2>
                        <p>Effective Date: 04/01/2020</p>
                        <p>Applicable To The Following Mobile Application:</p>
                        <p>Orlando Children's Church</p>
                    </center>
                    <br></br>

                    <h4>Article 1 - DEFINITIONS:</h4>
                    <hr></hr>
                    <br></br>
                    <div>
                        <ol type='a'>
                            <li>
                                <b>APPLICABLE MOBILE APPLICATION:</b> This Privacy Policy will refer to and be applicable to the Mobile App 
                                listed above, which shall hereinafter be referred to as "Mobile App."
                            </li>
                            <li>
                                <b>EFFECTIVE DATE:</b> "Effective Date" means the date this Privacy Policy comes into force and effect.
                            </li>
                            <li>
                                <b>PARTIES:</b> The parties to this privacy policy are the following data controller: Orlando Children's Church 
                                LLC ("Data Controller") and you, as the user of this Mobile App. Hereinafter, the parties will 
                                individually be referred to as "Party" and collectively as "Parties."
                            </li>
                            <li>
                                <b>DATA CONTROLLER:</b> Data Controller is the publisher, owner, and operator of the Mobile App and is the Party 
                                responsible for the collection of information described herein. Data Controller shall be referred to either 
                                by Data Controller's name or "Data Controller," as listed above. If Data Controller or Data Controller's 
                                property shall be referred to through first-person pronouns, it shall be through the use of the 
                                following: us, we, our, ours, etc.
                            </li>
                            <li>
                                <b>YOU:</b> Should you agree to this Privacy Policy and continue your use of the Mobile App, you 
                                will be referred to herein as either you, the user, or if any second-person pronouns are required and 
                                applicable, such pronouns as 'your", "yours", etc.
                            </li>
                            <li>
                                <b>PERSONAL DATA:</b> "Personal DATA" means personal data and information that we obtain from you 
                                in connection with your use of the Mobile App that is capable of identifying you in any manner.
                            </li>
                        </ol>
                    </div>
                    <br></br>

                    <h4>Article 2 - GENERAL INFORMATION:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        This privacy policy (hereinafter "Privacy Policy") describes how we collect and use the Personal Data that we 
                        receive about you, as well as your rights in relation to that Personal Data, when you visit our Mobile App and 
                        interact with it in any way, including passively.<br></br><br></br>
                        This Privacy Policy does not cover any information that we may receive about you through sources other than the 
                        use of our Mobile App. The Mobile App may link out to other websites or mobile applications, but this Privacy 
                        Policy does not and will not apply to any of those linked websites or applications.<br></br><br></br>
                        We are committed to the protection of your privacy while you use our Mobile App.<br></br><br></br>
                        By continuing to use our Mobile App, you acknowledge that you have had the chance to review and consider this 
                        Privacy Policy, and you acknowledge that you agree to it. This means that you also consent to the use of your 
                        information and the method of disclosure as described in this Privacy Policy. If you do not understand the Privacy 
                        Policy or do not agree to it, then you agree to immediately cease your use of our Mobile App.

                    </p>
                    <br></br>

                    <h4>Article 3 -CONTACT AND DATA PROTECTION OFFICER:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        The Party responsible for the processing of your personal data is as follows: Orlando Children's Church LLC. 
                        The Data Controller may be contacted as follows:
                    </p>
                    <p style={{marginLeft: "15px"}}>
                        info@orlandochildrenschurch.org<br></br>
                        PO Box 724<br></br>
                        Winter Park FL 32790<br></br>
                    </p>
                    <p>
                        The Data Controller and operator of the Mobile App are one and the same.
                    </p>
                    <p>
                        The Data Protection Officer is as follows: Janice Woody. The Data Protection Officer may be contacted as follows:
                    </p>
                    <p style={{marginLeft: "15px"}}>
                        janice@orlandochildrenschurch.org<br></br>
                        PO Box 724<br></br>
                        Winter Park FL 32790<br></br>
                    </p>
                    <br></br>

                    <h4>Article 4 - LOCATION:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        Please be advised the data processing activities take place in the United States, outside the European 
                        Economic Area. Data may also be transferred to companies within the United States, but will only be done so 
                        in a manner that complies with the EU's General Data Protection Regulation or GDPR. The location where the data 
                        processing activities take place is as follows:
                    </p>
                    <p style={{marginLeft: "15px"}}>
                        1950 Mohican Trail<br></br>
                        Maitland FL 32751<br></br>
                    </p>
                    <br></br>

                    <h4>Article 5 - MODIFICATIONS AND REVISIONS:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        We reserve the right to modify, revise, or otherwise amend this Privacy Policy at any time and in any manner. 
                        If we do so, however, we will notify you and obtain your consent to the change in processing. Unless we 
                        specifically obtain your consent, any changes to the Privacy Policy will only impact the information collected 
                        on or after the date of the change. It is also your responsibility to periodically check this page for any such 
                        modification, revision or amendment.
                    </p>
                    <br></br>

                    <h4>Article 6 - THE PERSONAL DATA WE RECEIVE FROM YOU:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        Depending on how you use our Mobile App, you will be subject to different types of Personal Data 
                        collected and different manners of collection:
                    </p>
                    <div style={{marginLeft: "25px"}}>
                        <p>
                            <b>a) Registered users:</b>  You, as a user of the Mobile App, may be asked to register in order to 
                            use the Mobile App in a legal manner. During the process of your registration, we will collect some of the 
                            following Personal Data from you through your voluntary disclosure:
                        </p>
                        <p style={{marginLeft: "50px"}}>
                            Name, address, email, cell number, birthdate, availability to volunteer, experience, photo, certifications
                        </p>
                        <p>
                            Personal Data may be asked for in relation to:
                        </p>
                        <ol type="I" style={{marginLeft: '25px'}}>
                            <li>
                                Interaction with our representatives in any way.
                            </li>
                            <li>
                                Receiving notifications by text message or email about marketing.
                            </li>
                            <li>
                                Receiving general emails from us.
                            </li>
                            <li>
                                Commenting on our content or other user-generated content on our Mobile App, such as blogs, articles, 
                                photographs or videos, or participating in our forums, bulletin boards, chat rooms or other similar 
                                features.
                            </li>
                            <li>
                                Or the following other forms of participation:
                                <p style={{marginLeft: "50px"}}>
                                    To update calendars.<br></br>
                                    Add notes about events.
                                </p>
                            </li>
                        </ol>
                        <p>
                            By undergoing the registration process, you consent to us collecting your Personal Data, including the 
                            Personal Data described in this clause, as well as storing, using or disclosing your Personal Data in 
                            accordance with this Privacy Policy.
                        </p>
                        <p>
                            <b>b) Unregistered users:</b> If you are a passive user of the Mobile App and do not register at all, 
                            you may still be subject to certain passive data collection ("Passive Data Collection"). Such Passive Data 
                            Collection may include through cookies, as described below, IP address information, location information, 
                            and certain browser data, such as history and/or session information.
                        </p>
                        <p>
                            <b>c) All users:</b> The Passive Data Collection that applies to Unregistered users shall also apply to 
                            all other users and/or visitors of our Mobile App.
                        </p>
                        <p>
                            <b>d) Email Marketing:</b> You may be asked to provide certain Personal Data, such as your name and email 
                            address, for the purpose of receiving email marketing communications. This information will only be obtained 
                            through your voluntary disclosure and you will be asked to affirmatively opt-in to email marketing 
                            communications.
                        </p>
                        <p>
                            <b>e) Content Interaction:</b> Our Mobile App may allow you to comment on the content that we provide or 
                            the content that other users provide, such as blogs, multimedia, or forum posts. If so, we may collect 
                            some Personal Data from you at that time, such as, but not limited to, username or email address.
                        </p>

                    </div>
                    <br></br>

                    <h4>Article 7 - THE PERSONAL DATA WE RECEIVE AUTOMATICALLY:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        <b>Cookies:</b> We may collect information from you through automatic tracking systems (such as information 
                        about your browsing preferences) as well as through information that you volunteer to us (such as information 
                        that you provide during a registration process or at other times while using the Mobile App, as described above).
                    </p>
                    <p>
                        For example, we use cookies to make your browsing experience easier and more intuitive: cookies are small 
                        strings of text used to store some information that may concern the user, his or her preferences or the device 
                        they are using to access the internet (such as a computer, tablet, or mobile phone). Cookies are mainly used to 
                        adapt the operation of the site to your expectations, offering a more personalized browsing experience and 
                        memorizing the choices you made previously.
                    </p>
                    <p>
                        A cookie consists of a reduced set of data transferred to your browser from a web server and it can only be 
                        read by the server that made the transfer. This is not executable code and does not transmit viruses.
                    </p>
                    <p>
                        Cookies do not record or store any Personal Data. If you want, you can prevent the use of cookies, but 
                        then you may not be able to use our Mobile App as we intend. To proceed without changing the options 
                        related to cookies, simply continue to use our Mobile App.
                    </p>
                    <div style={{marginLeft: "25px"}}>
                        <p>
                            <b>Technical Cookies:</b> Technical cookies, which can also sometimes be called HTML cookies, are 
                            used for navigation and to facilitate your access to and use of the site. They are necessary for the 
                            transmission of communications on the network or to supply services requested by you. The use of technical 
                            cookies allows the safe and efficient use of the site.
                        </p>
                        <p>
                            You can manage or request the general deactivation or cancelation of cookies through your browser. If 
                            you do this though, please be advised this action might slow down or prevent access to some parts of the site.
                        </p>
                        <p>
                            Cookies may also be retransmitted by an analytics or statistics provider to collect aggregated information 
                            on the number of users and how they visit the Mobile App. These are also considered technical cookies when 
                            they operate as described.
                        </p>
                        <p>
                            Temporary session cookies are deleted automatically at the end of the browsing session - these are mostly 
                            used to identify you and ensure that you don't have to log in each time - whereas permanent cookies 
                            remain active longer than just one particular session.
                        </p>
                        <p>
                            <b>Support in configuring your browser:</b> You can manage cookies through the settings of your browser 
                            on your device. However, deleting cookies from your browser may remove the preferences you have set for 
                            this Mobile App.
                        </p>
                        <p>
                            For further information and support, you can also visit the specific help page of the web browser 
                            you are using:
                        </p>
                        <ul style={{marginLeft: '25px'}}>
                            <li>
                                Internet Explorer: http://windows.microsoft.com/en-us/windows-vista/block-or-allow-cookies
                            </li>
                            <li>
                                Firefox: https://support.mozilla.org/en-us/kb/enable-and-disable-cookies-website-preferences
                            </li>
                            <li>
                                Safari: http://www.apple.com/legal/privacy/
                            </li>
                            <li>
                                Chrome: https://support.google.com/accounts/answer/61416?hl=en
                            </li>
                            <li>
                                Opera: http://www.opera.com/help/tutorials/security/cookies/
                            </li>
                        </ul>
                        <p>
                            Log Data: Like all websites and mobile applications, this Mobile App also makes use of log files that 
                            store automatic information collected during user visits. The different types of log data could be as follows:
                        </p>
                        <ul style={{marginLeft: '25px'}}>
                            <li>
                                internet protocol (IP) address;
                            </li>
                            <li>
                                type of browser and device parameters used to connect to the Mobile App;
                            </li>
                            <li>
                                name of the Internet Service Provider (ISP);
                            </li>
                            <li>
                                date and time of visit;
                            </li>
                            <li>
                                web page of origin of the user (referral) and exit;
                            </li>
                            <li>
                                possibly the number of clicks.
                            </li>
                        </ul>
                    </div>
                    <p>
                        The aforementioned information is processed in an automated form and collected in an exclusively aggregated 
                        manner in order to verify the correct functioning of the site, and for security reasons. This information will 
                        be processed according to the legitimate interests of the Data Controller.
                    </p>
                    <p>
                        For security purposes (spam filters, firewalls, virus detection), the automatically recorded data may also possibly include 
                        Personal Data such as IP address, which could be used, in accordance with applicable laws, in order to block attempts at 
                        damage to the Mobile App or damage to other users, or in the case of harmful activities or crime. Such data are never used for 
                        the identification or profiling of the user, but only for the protection of the Mobile App and our users. Such information will 
                        be treated according to the legitimate interests of the Data Controller.
                    </p>
                    <br></br>

                    <h4>Article 8 - HOW PERSONAL DATA IS STORED:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        We use secure physical and digital systems to store your Personal Data when appropriate. We ensure that your 
                        Personal Data is protected against unauthorized access, disclosure, or destruction.
                    </p>
                    <p>
                        Please note, however, that no system involving the transmission of information via the internet, or the electronic storage 
                        of data, is completely secure. However, we take the protection and storage of your Personal Data very seriously. We take 
                        all reasonable steps to protect your Personal Data.
                    </p>
                    <p>
                        The systems that we use to store your information include but are not limited to:
                    </p>
                    <div style={{marginLeft: '25px'}}>
                        <p>
                            We ensure that only a handful of staff have access to personal data.
                        </p>
                    </div>
                    <p>
                        Personal Data is stored throughout your relationship with us. We delete your Personal Data upon request for cancelation of 
                        your account or other general request for the deletion of data.
                    </p>
                    <p>
                        In the event of a breach of your Personal Data, you will be notified in a reasonable time frame, but in no event later 
                        than two weeks, and we will follow all applicable laws regarding such breach.
                    </p>
                    <br></br>

                    <h4>Article 9 - PURPOSES OF PROCESSING OF PERSONAL DATA:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        We primarily use your Personal Data to help us provide a better experience for you on our Mobile App and to provide you the 
                        services and/or information you may have requested, such as use of our Mobile App.
                    </p>
                    <p>
                        Information that does not identify you personally, but that may assist in providing us broad overviews of our customer base, 
                        will be used for market research or marketing efforts. Such information may include, but is not limited to, interests based on 
                        your cookies.
                    </p>
                    <p>
                        Personal Data that may be considering identifying may be used for the following:
                    </p>
                    <ol type='a' style={{marginLeft: '25px'}}>
                        <li>
                            Improving your personal user experience
                        </li>
                        <li>
                            Communicating with you about your user account with us
                        </li>
                        <li>
                            Marketing and advertising to you, including via email
                        </li>
                    </ol>

                    <h4>Article 10 - DISCLOSURE OF PERSONAL DATA:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        Although our policy is to maintain the privacy of your Personal Data as described herein, we may disclose your 
                        Personal Data if we believe that it is reasonable to do so in certain cases, in our sole and exclusive discretion. 
                        Such cases may include, but are not limited to:
                    </p>
                    <ol type='a' style={{marginLeft: '25px'}}>
                        <li>
                            To satisfy any local, state, or Federal laws or regulations
                        </li>
                        <li>
                            To respond to requests, such discovery, criminal, civil, or administrative process, subpoenas, court orders, or writs from 
                            law enforcement or other governmental or legal bodies
                        </li>
                        <li>
                            To bring legal action against a user who has violated the law or violated the terms of use of our Mobile App
                        </li>
                        <li>
                            As may be necessary for the operation of our Mobile App
                        </li>
                        <li>
                            To generally cooperate with any lawful investigation about our users
                        </li>
                        <li>
                            If we suspect any fraudulent activity on our Mobile App or if we have noticed any activity which may violate our terms or 
                            other applicable rules
                        </li>
                    </ol>

                    <h4>Article 11 - OPTING OUT OF TRANSMITTALS FROM US:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        From time to time, we may send you informational or marketing communications related to our Mobile App such as announcements 
                        or other information. If you wish to opt-out of such communications, you may contact the following email: 
                        info@orlandochildrenschurch.org. You may also click the opt-out link which will be provided at the bottom of any and all 
                        such communications.
                    </p>
                    <p>
                        Please be advised that even though you may opt-out of such communications, you may still receive information from us that 
                        is specifically about your use of our Mobile App or about your account with us.
                    </p>
                    <p>
                        By providing any Personal Data to us, or by using our Mobile App in any manner, you have created a commercial relationship 
                        with us. As such, you agree that any email sent from us or third-party affiliates, even unsolicited email, shall 
                        specifically not be considered SPAM, as that term is legally defined.
                    </p>

                    <h4>Article 12 - MODIFYING, DELETING, AND ACCESSING YOUR INFORMATION:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        If you wish to modify or delete any information we may have about you, or you wish to simply access any information we have 
                        about you, you may do so from your account settings page.
                    </p>

                    <h4>Article 13 - ACCEPTANCE OF RISK:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        By continuing to our Mobile App in any manner, use the Product, you manifest your continuing asset to this Privacy Policy. 
                        You further acknowledge, agree and accept that no transmission of information or data via the internet is not always 
                        completely secure, no matter what steps are taken. You acknowledge, agree and accept that we do not guarantee or warrant the 
                        security of any information that you provide to us, and that you transmit such information at your own risk.
                    </p>

                    <h4>Article 14 - YOUR RIGHTS:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        You have many rights in relation to your Personal Data. Specifically, your rights are as follows:
                    </p>
                    <ul style={{marginLeft: '25px'}}>
                        <li>
                            the right to be informed about the processing of your Personal Data
                        </li>
                        <li>
                            the right to have access to your Personal Data
                        </li>
                        <li>
                            the right to update and/or correct your Personal Data
                        </li>
                        <li>
                            the right to portability of your Personal Data
                        </li>
                        <li>
                            the right to oppose or limit the processing of your Personal Data
                        </li>
                        <li>
                            the right to request that we stop processing and delete your Personal Data
                        </li>
                        <li>
                            the right to block any Personal Data processing in violation of any applicable law
                        </li>
                        <li>
                            the right to launch a complaint with the Federal Trade Commission (FTC) in the United States or applicable data protection 
                            authority in another jurisdiction
                        </li>
                    </ul>
                    <p>
                        Such rights can all be exercised by contacting us at the relevant contact information listed in this 
                        Privacy Policy.
                    </p>

                    <h4>Article 15 - CONTACT INFORMATION:</h4>
                    <hr></hr>
                    <br></br>
                    <p>
                        If you have any questions about this Privacy Policy or the way we collect information from you, or if you would like to 
                        launch a complaint about anything related to this Privacy Policy, you may contact us at the following email address: 
                        info@orlandochildrenschurch.org.
                    </p>
                </div>
                
                
            </div>
        )
    }
}

const styling = {
    head: {
        // textAlign: "center"
    },
    outderdiv: {
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    }
}