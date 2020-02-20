import React, { Component } from 'react'

export class Profile extends Component {

    constructor(props){
        super(props)
        this.state = {
            username: ""

        }
    }
    
    

    render() {
        return (
            <div>
                <p>This is the profile page</p>
            </div>
        )
    }


}