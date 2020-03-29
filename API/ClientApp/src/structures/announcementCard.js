import React from 'react';


function AnnouncementCard(props) {
    return (
        <div>
            <h3>{props.header + " - " + props.date}</h3>
            <hr/>
            <p>{props.paragraph}</p>
            <br/>
            <br/>
        </div>
    )

}

export default AnnouncementCard

