import React, { Component } from 'react'
import { Button, Table } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import BootstrapTable from 'react-bootstrap-table-next'
import 'react-bootstrap-table-next/dist/react-bootstrap-table2.min.css'

// https://react-bootstrap-table.github.io/react-bootstrap-table2/docs/basic-celledit.html

export class ViewVolunteers extends Component {
    constructor(props) {
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            volunteers: [{}],
            redirect: false
        }
        console.log(this.state.jwt)
        this.getVolunteers()
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-dashboard',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }}/>
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    getVolunteers = () => {
        fetch('https://www.operation-portal.com/api/volunteer-list' , {
            // method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            }
        })
        .then((res) => {
            console.log(res.status)
            if((res.status === 200 || res.status === 201) && this.mounted === true){
                console.log('Retrieval successful')
                return res.text()
            }
            else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                console.log('Retrieval failed')
                return
            }
        })
        .then((data) => {
            let res = JSON.parse(data)
            res = res.volunteers
            if(this.mounted == true){
                this.setState({
                    volunteers: res
                })
            }
            console.log(this.state.volunteers)
        })
        .catch((err) => {
            console.log(err)
        })
    }

    // Sets variable to false when ready to leave page
    componentWillUnmount = () => {
        this.mounted = false
      }
  
      // Will set a variable to true when component is fully mounted
       componentDidMount = () => {
        this.mounted = true
      }

    render() {
        const products = this.state.volunteers.map(v => {
            [
                {
                    'pref': v.preferredName,
                    'first': 'aaa',
                    'last': '2001',
                    'role': '2001',
                    'weeks': '2001',
                    'phone': '2001',
                    'email': '2001',
                    'ori': '2001',
                    'train': '2001',
                    'aff': '2001',
                    'ref': '2001',
                    'lang': '2001',
                    'class': '2001',
                    'ages': '2001',
                    'news': '2001',
                    'contact': '2001',
                    'back': '2001',
                    'blue': '2001',
                    'nametag': '2001',
                    'interview': '2001',
                    'year': '2001',
                    'birthday': '2001',
                }
            ]
        })
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <BootstrapTable 
                    keyField='id' 
                    data={ products } 
                    columns={ columns } 
                    style= {styling.table}
                />
            </div>
        )
    }
}

// if(this.state.volunteers != null){
//     const products = this.state.volunteers.map(v => {
//         [
//             {
//                 'pref': v.preferredName,
//                 'first': 'aaa',
//                 'last': '2001',
//                 'role': '2001',
//                 'weeks': '2001',
//                 'phone': '2001',
//                 'email': '2001',
//                 'ori': '2001',
//                 'train': '2001',
//                 'aff': '2001',
//                 'ref': '2001',
//                 'lang': '2001',
//                 'class': '2001',
//                 'ages': '2001',
//                 'news': '2001',
//                 'contact': '2001',
//                 'back': '2001',
//                 'blue': '2001',
//                 'nametag': '2001',
//                 'interview': '2001',
//                 'year': '2001',
//                 'birthday': '2001',
//             }
//         ]
//     })
// }


// const products = [
//     {
//         'pref': '5',
//         'first': 'aaa',
//         'last': '2001',
//         'role': '2001',
//         'weeks': '2001',
//         'phone': '2001',
//         'email': '2001',
//         'ori': '2001',
//         'train': '2001',
//         'aff': '2001',
//         'ref': '2001',
//         'lang': '2001',
//         'class': '2001',
//         'ages': '2001',
//         'news': '2001',
//         'contact': '2001',
//         'back': '2001',
//         'blue': '2001',
//         'nametag': '2001',
//         'interview': '2001',
//         'year': '2001',
//         'birthday': '2001',

//     }
// ]
const columns = [
    {
        dataField: 'pref',
        text: 'Preferred Name'
    }, 
    {
        dataField: 'first',
        text: 'First Name'
    },
    {
        dataField: 'last',
        text: 'Last Name'
    }, 
    {
        dataField: 'role',
        text: 'Role'
    },
    {
        dataField: 'weeks',
        text: 'Weeks Attended'
    },
    {
        dataField: 'phone',
        text: 'Phone Number'
    },
    {
        dataField: 'email',
        text: 'Email'
    },
    {
        dataField: 'ori',
        text: 'Orientation'
    },
    {
        dataField: 'train',
        text: 'Trainings'
    },
    {
        dataField: 'aff',
        text: 'Affiliations'
    },
    {
        dataField: 'ref',
        text: 'Referral'
    },
    {
        dataField: 'lang',
        text: 'Languages'
    },
    {
        dataField: 'class',
        text: 'Classes Interested'
    },
    {
        dataField: 'ages',
        text: 'Ages Interested'
    },
    {
        dataField: 'news',
        text: 'News Letter'
    },
    {
        dataField: 'contact',
        text: 'Contact When Short'
    },
    {
        dataField: 'back',
        text: 'Background Check'
    },
    {
        dataField: 'blue',
        text: 'Blue Shirt'
    },
    {
        dataField: 'nametag',
        text: 'Name Tag'
    },
    {
        dataField: 'interview',
        text: 'Personal Interview Completed'
    },
    {
        dataField: 'year',
        text: 'Year Started'
    },
    {
        dataField: 'birthday',
        text: 'Birthday'
    }
]

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
    table: {
        height: '400px',
        width: '1000px'
    }
}