import React, { Component } from 'react'
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class AdminViewGroups extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            clicked: props.location.state.clicked,
            groups: [{}],
            result: false,
            rendergroups: false
        }
        this.getGroups()
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

    getGroups = () => {
        var a = this.state.clicked
        var date = a.month + '/' + a.day + '/' + a.year
        try {
            fetch('api/calendar/details?date=' + date, {
                // method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`,
                    'Accept': 'application/json'
                },
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('get group successful')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('get group unsuccessful')
                    return res.text()
                }
            })
            .then((data) => {
                var res = JSON.parse(data)
                if(res.groups != null) {
                    res = res.groups
                    this.setState({
                        groups: res,
                        rendergroups: true
                    })
                }
                console.log(res)
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    cancelGroup = (ep) => {
        console.log(ep)
        let a = ep.date
        let year = a.substring(0, 4)
        let month = a.substring(5, 7)
        let day = a.substring(8, 10)
        let nue = year + '-' + month + '-' + day
        console.log(nue)
        try {
            fetch('api/calendar/cancellation/group', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`,
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    'date': nue,
                    'groupId': ep.id
                })
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('cancel group successful')
                    this.setState({
                        result: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('cancel group unsuccessful')
                    this.setState({
                        result: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                if(this.state.result){
                    this.setState({
                        redirect: true
                    })
                }
            })

        }
        catch(e) {
            console.log(e)
        }
    }

    // POST api/calendar/cancellation/group
    // Roles accessed by: staff
    // Input:
    // {“date”: “DateTime”, “groupId”: “int”}

    

    showGroups = () => {
        console.log(this.state.clicked)
        if(this.state.rendergroups === true && this.state.groups != null){
            let eve = this.state.groups.map((e, index) => {
                var value = e.phone;
                var numberPattern = /\d+/g;
                value = value.match( numberPattern ).join([]);

                var num = '(' + value.substring(0, 3) + ') ' + value.substring(3, 6) + '-' + value.substring(6, 10)
                

                return (
                    <div key={index} style={styling.eves}>
                        <h2>Group Name: {e.name}</h2>
                        <hr></hr>
                        <p>Group Leader Name: {e.leaderName}</p>
                        <p>Group Size: {e.count}</p>
                        <p>Phone Number: {num}</p> 
                        <p>Email: {e.email}</p>
                        <Button variant="primary" size="sm" style={styling.sc} onClick={() => {this.cancelGroup(e)}}>
                            Cancel Attendance
                        </Button> 
                        <br></br>
                        <br></br>
                    </div>
                )
            })
            return eve

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
                <h1 style={styling.head}>Viewing all Attending Groups for {date}</h1>
                <div style={styling.outerdiv}>
                    {this.showGroups()}
                </div>
            </div>
        )
    }
}

const styling = {
    cal: {
        height: '550px',
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    },
    add: {
        marginBottom: '25px'
    },
    head: {
        marginBottom: "15px",
        textAlign: "center"
    },
    outerdiv: {
        padding: '20px 20px',
        marginLeft: '75px',
        marginRight: '75px'
    },
    sc: {
        marginRight: '50px'
    }
} 


