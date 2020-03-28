/* 
* Generated by
* 
*      _____ _          __  __      _     _
*     / ____| |        / _|/ _|    | |   | |
*    | (___ | | ____ _| |_| |_ ___ | | __| | ___ _ __
*     \___ \| |/ / _` |  _|  _/ _ \| |/ _` |/ _ \ '__|
*     ____) |   < (_| | | | || (_) | | (_| |  __/ |
*    |_____/|_|\_\__,_|_| |_| \___/|_|\__,_|\___|_|
*
* The code generator that works in many programming languages
*
*			https://www.skaffolder.com
*
*
* You can generate the code from the command-line
*       https://npmjs.com/package/skaffolder-cli
*
*       npm install -g skaffodler-cli
*
*   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *
*
* To remove this comment please upgrade your plan here: 
*      https://app.skaffolder.com/#!/upgrade
*
* Or get up to 70% discount sharing your unique link:
*       https://app.skaffolder.com/#!/register?friend=5e7f4c1806e8563f3229b900
*
* You will get 10% discount for each one of your friends
* 
*/
import Properties from "../../properties";
import Database from "../../classes/Database_QReview_db";
import Errors from "../../classes/Errors";

// Factom
import Factom from "factom-harmony-connect";
import ChainModel from "./ChainModel";
import uuid from "uuid/v1";

const factomConnectSDK = new Factom(Properties.factom.config);

export default {
  /**
   * IdentityModel.create
   * @description CRUD ACTION create
   */
  create: async () => {
    // Generate an unique ID for the identity
    const id = uuid();

    try {
      const {
        chain_id,
        entry_hash,
        key_pairs
      } = await factomConnectSDK.identities.create({
        names: [id]
      });

      let result = await Database.getConnection().models.Identity.create({
        chain_id,
        entry_hash,
        key_pairs
      });

      const insertedId = result.dataValues._id;

      // Create Audit and Management Chain
      const auditChain = await ChainModel.create(
        key_pairs[0].private_key,
        chain_id,
        "Audit Chain",
        entry_hash,
        insertedId
      );
      const managementChain = await ChainModel.create(
        null,
        chain_id,
        "Management Chain",
        entry_hash,
        insertedId
      );

      // Return the id inserted
      return insertedId;
    } catch (e) {
      if (e.response.status === 403) {
        throw new Errors.INVALID_AUTH_FACTOM();
      } else if (e.response.status === 429) {
        throw new Errors.EXCEDEED_LIMIT_REQUEST();
      }
    }
  },

  /**
   * IdentityModel.list
   *  @description CRUD ACTION list
   *
   */
  async list() {
    let list = await Database.getConnection().models.Identity.findAll();
    return list;
  }
};
