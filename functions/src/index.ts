import * as functions from 'firebase-functions'
// import * as Firestore from '@google-cloud/firestore';
import * as admin from 'firebase-admin'
admin.initializeApp({
    credential: admin.credential.cert(require('../src/superSecret.json'))
})
// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

// exports.addMessage = functions.https.onRequest(async (req, res) => {

//     // const writeResult = 
//     return admin.firestore().collection('Test').add({ original: req.query.text }).then(
//         (thing) => {
//             res.json({ result: `Message with ID: ${thing.id} added.` })
//             res.send()
//         }
//     ).catch(e => {
//         console.log(e)
//         res.send("There was an error again")
//     })

//     // return writeResult
// })

exports.setTargets = functions.https.onRequest(async (req, res) => {
    /// THe purpose of this function is to give every player in the specified game a target and update the database accordingly.

    const id: string = req.query.gameid?.toString()!
    console.log("THe ID: 33333333333333333333333333333333333333333333333333333")
    console.log(id)
    try {
        /// THis part loads the Players collection from the appropriate game depending on the Game ID passed in
        const PlayersQ = await admin.firestore().collection("Games").doc(id).collection("Players").get()
        // console.log("PlayersQ: *********************************************")
        // console.log(PlayersQ)
        const PlayerDocs = PlayersQ.docs
        // console.log("PlayerDocs: ********************************************")
        // console.log(PlayerDocs)

        /// This randomizes the order of the Player documents inthe PlayerDocs Array
        for (let q = PlayerDocs.length - 1; q > 0; q--) {
            const j = Math.floor(Math.random() * q)
            const temp = PlayerDocs[q]
            PlayerDocs[q] = PlayerDocs[j]
            PlayerDocs[j] = temp
        }
        console.log("Randomized")

        /// This loop is to actually make the pairings and assign everyone a target.
        let i
        let prevPlayer = PlayerDocs[0].data()['Username']
        let currPlayer
        const promises = []
        for (i = 1; i < PlayerDocs.length; i++) {
            currPlayer = PlayerDocs[i].data()['Username']
            console.log(`${currPlayer} target is ${prevPlayer}`)
            // console.log(`$CurrPlayer ID ${PlayerDocs[i].id}`)
            promises.push(admin.firestore().collection("Games").doc(id).collection("Players").doc(PlayerDocs[i].id).update({ 'Targetname': prevPlayer },))
            prevPlayer = currPlayer
        }
        console.log(`${PlayerDocs[0].data()['Username']} target is ${currPlayer}`);
        promises.push(admin.firestore().collection("Games").doc(id).collection("Players").doc(PlayerDocs[0].id).update({ 'Targetname': currPlayer },))


        res.send("its done")

        await Promise.all(promises)
        return
    } catch (e) {
        console.log(e)
        return
    }
})

exports.Eliminate = functions.https.onCall((data, context) => {
    let part


    try {
        const currentGameID = data.gameID
        const callerID = context.auth?.uid!

        if (!context.auth) {
            return { status: 'error', code: 401, message: 'not signed in' }
        }

        part = 1

        return admin.firestore().collection("Games").doc(currentGameID).collection("Players").doc(callerID).get().then(async(doc) => {
            if (!doc.exists) {
                return { status: 'error', code: 401, message: "User's Player not found" }
            }

            part = 2

            const targetName = doc.data()!["Targetname"]

            return admin.firestore().collection("Games").doc(currentGameID).collection("Players").where("Username", "==", targetName).get().then(async(Q) => {
               
                if (Q === undefined) {
                    return { status: 'error', code: 401, message: "TargetQ undefinded" }
                }
               
                if (!Q.docs[0].exists) {
                    return { status: 'error', code: 401, message: "Target Player not found", info: Q.toString() }
                }

                const targetstarget = Q.docs[0].data()["Targetname"]
                const targetID = Q.docs[0].id

                return admin.firestore().collection("Games").doc(currentGameID).collection("Players").doc(callerID).update({ 'Targetname': targetstarget },).then(
                    async () => {
                        await admin.firestore().collection("Games").doc(currentGameID).collection("Players").doc(targetID).delete()
                        return { status: 'good', code: 401, message: 'executed', uzerid: callerID, gameid: currentGameID, target: targetName, newtarget: targetstarget }
                    }
                )

                // return { status: 'bad', code: 401, message: 'fell out out', uzerid: callerID, gameid: currentGameID }

            }).catch(e => { return { status: 'error', code: 401, message: "Target Player idk", info: e.toString() } })

            // return { status: 'bad', code: 401, message: 'fell out outer', uzerid: callerID, gameid: currentGameID }
        })

        // return Promise.resolve(done)
        // { status: 'bad', code: 401, message: 'fell outout', uzerid: callerID, gameid: currentGameID }

    } catch (err) {

        console.log(err.toString())
        return { status: 'error', code: 401, message: 'idkkkkkkk ------------', error: err.toString(), errorpart: part }
    }
});


// exports.helloWorld = functions.https.onRequest((request, response) => {
//     response.send("Hello from Firebase!");
//    });