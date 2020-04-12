import React, { Component } from 'react'
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class AdminAllAnnouncements extends Component {
    constructor(props) {
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            redirect: false,
            tog: false
        }
        this.getAnnouncements()
    }

    componentWillUnmount = () => {
        this.mounted = false
    }
    
    componentDidMount = () => {
        this.mounted = true
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirect){
            return (
                <Redirect to={{
                    pathname: '/admin-dashboard',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin
                    }
                }}/>
            )
        }
        else if(this.state.tog){
            return (
                <Redirect to={{
                    pathname: '/admin-announcements',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin
                    }
                }}/>
            )
        }
    }

    getAnnouncements = () => {
        try {
            fetch('api/announcements?activeOnly=' + false , {
                // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('announcements received')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('announcements not received')
                    return
                }
            })
            .then((data) => {
                if(data != null){
                    var res = JSON.parse(data)
                    res = res.announcements
                    this.setState({
                        announcements: res
                    })
                    console.log(this.state.announcements)
                }
                
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    renderAnnouncements = () => {
        if(this.state.announcements != null) {
            let a = this.state.announcements.map((details, index) => {

                let startyear = details.startDate.substring(0, 4)
                let startmonth = details.startDate.substring(5, 7)
                let startday = details.startDate.substring(8, 10)
                let startdate = startmonth + '/' + startday + '/' + startyear

                let endyear = details.endDate.substring(0, 4)
                let endmonth = details.endDate.substring(5, 7)
                let endday = details.endDate.substring(8, 10)
                let enddate = endmonth + '/' + endday + '/' + endyear

                return (
                    <div key={index}>
                        <h3>{details.title} {startdate + '-' + enddate}</h3>
                        <hr></hr>
                        <p>{details.message}</p>
                        <br></br>
                    </div>
                )
            })
            return a
        }
        
    }

    setToggle = () => {
        this.setState({
            tog: true
        })
    }

    render() {
        
        return (
            <div >
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>

                <Button variant="primary" size="lg" style={styling.ann} className="float-right">
                    Add New Annoucements
                </Button>
                <h1 style={styling.head}>Weekly Announcements</h1>
                <div style={styling.outderdiv} >
                    <Button variant="primary" size="sm" style={styling.show} onClick={this.setToggle}>
                            Show Relevant Announcements
                    </Button>
                    {this.renderAnnouncements()}
                    
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
    },
    ann: {
        marginTop: '15px',
        marginRight: '15px',
        marginBottom: '15px'
    },
    show: {
        marginBottom: '20px'
    }
}