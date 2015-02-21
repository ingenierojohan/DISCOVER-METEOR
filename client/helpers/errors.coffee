#Coleccion para el Manejo de Error  no Persistente
Errors = new Mongo.Collection(null)
@Errors = Errors

@throwError = (message)->
  Errors.insert(
    message:message
)