import React, { Component } from 'react';
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import './cards.css'


export class AdminAllAbsences extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            clicked: props.location.state.clicked,
            absences: [{}],
            retrieved: false
        }
        console.log(this.state.clicked)
        this.getAbsences()

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
        if(this.state.redirect) {
            return (
                <Redirect to={{
                    pathname: '/admin-calendar',
                    state: {
                        jwt: this.state.jwt
                    }
                }}/>
            )
        }
    }

    getAbsences = () => {
        var a = this.state.clicked
        var date = a.month + '/' + a.day + '/' + a.year
        try {
            fetch('api/calendar/details?date=' + date , {
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
                    console.log(date + ' details successful')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log(date + ' details unsuccessful')
                    return res.text()
                }
            })
            .then((data) => {
                var res = JSON.parse(data)
                if(res.absences != null) {
                    res = res.absences
                    this.setState({
                        retrieved: true,
                        absences: res
                    })
                    console.log(this.state.absences)
                }
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    renderAbsences = () => {
        if(this.state.retrieved){
            let eve = this.state.absences.map((v, index) => {
                // let a = e.date
                // let year = a.substring(0, 4)
                // let month = a.substring(5, 7)
                // let day = a.substring(8, 10)
                // let nue = month + '/' + day + '/' + year
                return (
                    <div key={index}>
                        <Card style={{width: '25rem'}}>
                            <Card.Header as='h5'>
                                {v.firstName + " " +  v.lastName}
                            </Card.Header>
                            <Card.Body>
                                <Card.Title>
                                    Information
                                </Card.Title>
                                <Card.Text>
                                    ID: {v.id}<br></br>
                                    Preferred Name: {v.preferredName}<br></br>
                                    Email: {v.email}<br></br>
                                    Phone: {v.phone}<br></br>
                                    Birthday: {v.birthday}<br></br>
                                    <br></br>
                                    Role: {v.role}<br></br>
                                    Weeks Attended: {v.weeksAttended}<br></br>
                                    {/* trainings, languages, picture, bus, class, classes interested, 
                                        ages interested, 
                                     */}
                                    <br></br>
                                    Orientation: {v.orientation ? 'Yes' : 'No'}<br></br>
                                    Blue Shirt: {v.blueShirt  ? 'Yes' : 'No'}<br></br>
                                    Name Tag: {v.nameTag  ? 'Yes' : 'No'}<br></br>
                                    Personal Interview: {v.personalInterviewCompleted  ? 'Yes' : 'No'}<br></br>
                                    Background Check: {v.backgroundCheck  ? 'Yes' : 'No'}<br></br>
                                    Year Started: {v.yearStarted}<br></br>
                                    Can Edit Inventory: {v.canEditInventory  ? 'Yes' : 'No'}<br></br>
                                </Card.Text>
                            </Card.Body>
                        </Card>
                    </div>
                )
            })
            return (
                <div className="row">
                    {eve}
                </div>
            )

        }
    }

    render() {
        var a = this.state.clicked
        var date = a.month + '/' + a.day + '/' + a.year
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <h1 style={styling.head}>All Absences on {date}</h1>
                <div style={styling.deckDiv}>
                    {this.renderAbsences()}
                </div>
            </div>
        )
    }
}

const styling = {
    head: {
        marginBottom: '15px',
        textAlign: "center"
    },
    outderdiv: {
        padding: '20px 20px',
        marginLeft: '75px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    },
    table: {
        height: '400px',
        width: '1000px'
    },
    deckDiv: {
        justifyContent: 'center',
        alignContent: 'center',
        outline: 'none',
        border: 'none',
        overflowWrap: 'normal',
        marginLeft:'7%'
    },
    ann: {
        marginTop: '15px',
        marginRight: '15px',
        marginBottom: '15px'
    }
}