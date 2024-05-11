
import { 
  CognitoIdentityProviderClient, 
  InitiateAuthCommand,
  AdminCreateUserCommand,
  AdminGetUserCommand, 
  AdminSetUserPasswordCommand } from "@aws-sdk/client-cognito-identity-provider";    
import { MongoClient, ServerApiVersion } from 'mongodb';
 
const dburl = process.env.DB_URL;


const client = new MongoClient(dburl, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

// process.env.USER_POOL_ID
const REGION = process.env.REGION; 
const USER_POOL_ID = process.env.USER_POOL_ID;
const CLIENT_ID = process.env.CLIENT_ID;
const permPass = process.env.PERM_PASS;

const cognitoClient = new CognitoIdentityProviderClient({ region: REGION });


async function getUser(cpf) {
  try {

    await client.connect();

    const db = client.db('food-fiap');
    const collection = db.collection('customer');
    const customer = await collection.findOne({ _id: String(cpf) });
    return customer

   }finally {
      await client.close();
    }
}

const initAuthCognitoUser = async(email) => {
  const params = {
    AuthFlow: 'USER_PASSWORD_AUTH',
    ClientId: CLIENT_ID,
    AuthParameters: {
      USERNAME: email,
      PASSWORD: permPass
    },
  }

  const command = new InitiateAuthCommand(params);
  const result = await cognitoClient.send(command)
  return result
}

const createCognitoUser = async(email, cpf) => {
  const cmdCreate = new AdminCreateUserCommand({
    UserPoolId: USER_POOL_ID,
    Username: email,
    TemporaryPassword: "123123",
    UserAttributes: [
      { Name: 'email', Value: email },
      { Name: 'email_verified', Value: 'true' }, 
      { Name: 'custom:cpf', Value: String(cpf) }
    ],
  })

  const created = await cognitoClient.send(cmdCreate)     

  const passUpdatedCmd = new AdminSetUserPasswordCommand(
    {
      Password: permPass,
      Username: email,
      UserPoolId: USER_POOL_ID,
      Permanent: true
    }
  )
  
  const passUpdatedResult = await cognitoClient.send(passUpdatedCmd) 
}

const getCognitoUser = async(email) => {
  try {
    const cmdGet = new AdminGetUserCommand({
      Username: email,
      UserPoolId: USER_POOL_ID
    })
    
    const getUserResult = await cognitoClient.send(cmdGet) 
    return getUserResult
  } catch(err) {
    if (err == 'UserNotFoundException') {
      return err
    }
  }
}


export const handler = async (event) => {
  const { cpf } = event.queryParams

  try {
    const customer = await getUser(cpf)

    console.info("Searching User on Cognito.")
    const userCogResult = await getCognitoUser(customer.email)
    
    if (!userCogResult) {
      console.log("Creating cognito User.")
      await createCognitoUser(customer.email, cpf)
      console.log("Cognito User created.")
    }
    console.log("Found User on Cognito.")

    const { email } = customer; 
    const result = await initAuthCognitoUser(email)

    const response = {
      AccessToken: result.AuthenticationResult.AccessToken, 
      headers: {
        "content-type" : "application/json"
      },
      statusCode: 200,
   };
    
    return response;  
  } catch (err) {
    console.log("Error do catch", err);
  }
}