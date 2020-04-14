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
                    <p>
                        
                    </p>
                    <br></br>

                    <h2 style={styling.head}>Service Providers</h2>
                    <hr></hr>
                    <br></br>
                    <p>
                        We may employ third-party companies and individuals due to the following reasons:
                    </p>
                    <ul>
                        <li>To facilitate our Service;</li>
                        <li>To provide the Service on our behalf;</li>
                        <li>To perform Service-related services; or</li>
                        <li>To assist us in analyzing how our Service is used.</li>
                    </ul>
                    <p>
                        We want to inform our Service users that these third parties have access to your Personal Information. 
                        The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to 
                        disclose or use the information for any other purpose.
                    </p>
                    <br></br>

                    <h2 style={styling.head}>Security</h2>
                    <hr></hr>
                    <br></br>
                    <p>
                        We value your trust in providing us your Personal Information, thus we are striving to use commercially 
                        acceptable means of protecting it. But remember that no method of transmission over the internet, or 
                        method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.
                    </p>
                    <br></br>

                    <h2 style={styling.head}>Links to Other Sites</h2>
                    <hr></hr>
                    <br></br>
                    <p>
                        Our Service may contain links to other sites. If you click on a third-party link, you will be directed to 
                        that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to 
                        review the Privacy Policy of these websites. We have no control over, and assume no responsibility for 
                        the content, privacy policies, or practices of any third-party sites or services.
                    </p>
                    <br></br>

                    <h2 style={styling.head}>Changes to This Privacy Policy</h2>
                    <hr></hr>
                    <br></br>
                    <p>
                        We may update our Privacy Policy from time to time. Thus, we advise you to review this page periodically 
                        for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. 
                        These changes are effective immediately, after they are posted on this page.
                    </p>
                    <br></br>

                    <h2 style={styling.head}>Contact Us</h2>
                    <hr></hr>
                    <br></br>
                    <p>
                        If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.
                    </p>
                    <br></br>
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