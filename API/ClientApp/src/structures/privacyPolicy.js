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
                    <h1 style={styling.head}>Privacy Policy of Orlando Children’s Church</h1>
                    <hr></hr>
                    <br></br>
                    <p>
                        Orlando Children's Church operates the operation-portal website, which provides access to information 
                        related to our organization which will hereby be referred to as ‘Service’.
                        This page is used to inform website visitors, as well as application visitors, regarding our policies with 
                        the collection, use, and disclosure of Personal Information if anyone decided to use our Service, the 
                        operation-portal website.
                        If you choose to use our Service, then you agree to the collection and use of information in 
                        relation with this policy. The Personal Information that we collected is used for providing and 
                        improving the Service. We will not use or share your information with anyone except as described in this 
                        Privacy Policy.
                    </p>
                    <br></br>

                    <h2 style={styling.head}>Information Collection and Use</h2>
                    <hr></hr>
                    <br></br>
                    <p>
                        For a better experience while using our Service, we may require you to provide us with certain personally 
                        identifiable information, including but not limited to your name, phone number, and image. The information 
                        that we collect will be used to contact or identify you.
                    </p>
                    <br></br>

                    <h2 style={styling.head}>Log Data</h2>
                    <hr></hr>
                    <br></br>
                    <p>
                        We want to inform you that whenever you use our Service, we collect information that your browser sends 
                        to us that is called Log Data. This Log Data may include information such as your computer's 
                        Internet Protocol (“IP”) address, browser version, pages of our Service that you visit, the time and date 
                        of your visit, the time spent on those pages, and other statistics.
                    </p>
                    <br></br>

                    <h2 style={styling.head}>Cookies</h2>
                    <hr></hr>
                    <br></br>
                    <p>
                        Cookies are files with a small amount of data that is commonly used as an anonymous unique identifier. 
                        These are sent to your browser from the website that you visit and are stored on your computer's hard drive.
                        Our website uses these “cookies” to collect information and to improve our Service. 
                        You have the option to either accept or refuse these cookies, and know when a cookie is being sent to your 
                        computer. If you choose to refuse our cookies, you may not be able to use some portions of our Service.

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
        textAlign: "center"
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