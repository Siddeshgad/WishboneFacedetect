
modelName = 'twitter_handles'

###Model for the table twitter_handles###
module.exports = (sequelize, DataTypes) ->
  TwitterHandles = sequelize.define(modelName,
    {
      id:
        type: DataTypes.INTEGER
        autoIncrement: true
        primaryKey: true
        allowNull: false

      name:
        type: DataTypes.STRING

      twitter_id:
        type: DataTypes.INTEGER

      screen_name:
        type: DataTypes.STRING(255)

  }, {
      tableName: modelName,
      createdAt: "created_at",
      updatedAt: "updated_at",
      deletedAt: "deleted_at",
      timestamps: true,
      paranoid: true,
      classMethods: {
        associate: (models) ->
          TwitterHandles.hasMany(models.meta_map, {
            foreignKey: 'author_id'
          })
      },
      indexes: [
        {
          name: 'twitter_idx',
          unique: true,
          fields: ['twitter_id']
        },
        {
          name: 'name_idx',
          unique: true,
          fields: ['name']
        }
      ]
  }
)