var parsedIssues = {}

parsedIssues.parsedIssue1 = {
    id: "96781159",
    created_by: "nelsonic",
    owner_name: "dwyl",
    repo_name: "tudo",
    avatar_url: "https://avatars.githubusercontent.com/u/12045918?v=3",
    title: "example issue JSON format",
    first_line: "when adding example files to repos always format them so they are as readable as possible (_for the next person_).  ",
    labels: [
        {
            "name": "enhancement",
            "color": "84b6eb"
        }
    ],
    updated_at: "2015-07-23T10:34:53Z",
    created_at: "2015-07-23T10:25:34Z",
    last_comment: "",
    number_of_comments: "0",
    issue_number: "56",
    assignee: "jrans"
};

parsedIssues.parsedIssue2 = {
    id: "96297684",
    created_by: "msmichellegar",
    owner_name: "dwyl",
    repo_name: "tudo",
    avatar_url: "https://avatars.githubusercontent.com/u/4185328?v=3",
    title: "Time labels in minutes or hours?",
    first_line: "Should \"time-estimate\" and \"time-actual\" labels display in the UI as hours or minutes?",
    labels: [
        {
          "name": "help wanted",
          "color": "159818"
        },
        {
          "name": "question",
          "color": "cc317c"
        }
    ],
    created_at: "2015-07-21T11:52:54Z",
    updated_at: "2015-07-23T09:52:33Z",
    last_comment: "Most people intuitively understand minutes up to a number depending on their reference point.\r\ne.g: \r\n+ People who watch/play sports will think in terms of **90mins**\r\n+ People who  watch lots of movies will be comfortable with **126mins**\r\n\r\nMy suggestion would be: everything over `{X}m` minutes should be displayed as `{H}h` (_preferably **rounded down** to the nearest hour_)\r\n\r\nBut, we need to figure out how to A/B test this... and ask for feedback from people *using* **Tudo**.",
    number_of_comments: "2",
    issue_number: "32",
    assignee: "iteles"
};

module.exports = parsedIssues;
