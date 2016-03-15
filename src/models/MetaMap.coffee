
modelName = 'meta_map'

###Model for the table twitter_handles###
module.exports = (sequelize, DataTypes) ->
  MetaMap = sequelize.define(modelName,
    {
      id:
        type: DataTypes.INTEGER
        autoIncrement: true
        primaryKey: true
        allowNull: false

      author_id:
        type: DataTypes.INTEGER

      meta_id:
        type: DataTypes.INTEGER
  }, {
      tableName: modelName,
      createdAt: "created_at",
      updatedAt: "updated_at",
      deletedAt: "deleted_at",
      timestamps: true,
      paranoid: true
  }
)