object valorASuperar{
	var property valor=0
}
class Club{
	var actividadesDelClub= #{}
	var gastosDelClub=0
	method condicionParaSancionIntegral()=self.cantidadDeSociosTotales()>500
	method puntajeTotalDeEvaluacionesDeLasActividades()=actividadesDelClub.sum({actividad=>actividad.evaluacion()})
	//TODO Revisar esta suma de abajo,ver las opciones de los conjuntos
	method cantidadDeSociosTotales()=actividadesDelClub.sum({actividad=>actividad.involucrados().size()})
	method aparecionesDe(jugador)=actividadesDelClub.count({actividad=>actividad.estaEsteMiembro(jugador)})
	method casoParticular(jugador)
	method sancionar(_unaActividad){
	  if(self.condicionParaSancionIntegral()){
		actividadesDelClub.forEach({actividad=>actividad.sancionar()})
	     }else{
	  	   _unaActividad.sancionar()
	      }
	}
	method evaluacionBruta()
	method evaluacion()=self.evaluacionBruta()-self.cantidadDeSociosTotales()
	method sociosDestacados()=actividadesDelClub.map({actividad=>actividad.socioDestacado()})
	method sociosDestacadosYEstrellas()=self.sociosDestacados().filter({socio=>socio.soySocioEstrella()})
	method clubPrestigioso()=actividadesDelClub.any({actividad=>actividad.esPrestigioso()})
}
class Profesional inherits Club{
	override method casoParticular(jugador)=jugador.valorDelPase()>valorASuperar.valor()
	override method evaluacionBruta()=self.puntajeTotalDeEvaluacionesDeLasActividades()*2-(gastosDelClub*5)
}
class Tradicional inherits Club{
	override method casoParticular(jugador)=jugador.valorDelPase()>valorASuperar.valor() or self.aparecionesDe(jugador)>3
	//TODO como ver que sancione a un club o a una actividad dependiendo del gusto
	override method condicionParaSancionIntegral()=true
	override method evaluacionBruta()=self.puntajeTotalDeEvaluacionesDeLasActividades()-gastosDelClub
}
class Comunitario inherits Club{
	override method casoParticular(jugador)=self.aparecionesDe(jugador)>3
	override method evaluacionBruta()=self.puntajeTotalDeEvaluacionesDeLasActividades()
	
}
class Equipo {
	var capitan 
	var plantel = #{capitan}
	var cantVecesSancionado=0
	var cantCampeonatosObtenidos=0
	method estaEsteMiembro(miembro)=plantel.contains(miembro)
	method involucrados()=plantel
	method sancionar(){
		cantVecesSancionado+=1
	}
	method disminucionDePuntosPorSanciones()=cantVecesSancionado*20
	method evaluacion()=cantCampeonatosObtenidos*2+plantel.size()*2 + if(capitan.soySocioEstrella()) 5 else 0 - (self.disminucionDePuntosPorSanciones())
	method socioDestacado()=capitan
	method somosExperimentados()=plantel.all({jugador=>jugador.partidosJugados()>=10})
	method esPrestigioso()=self.somosExperimentados()
	method esTrasferible(_unJugador,equipo)=(_unJugador!=capitan) and (equipo!=_unJugador.club())
	method transferirJugador(_unJugador,equipo){
		if(self.esTrasferible(_unJugador,equipo)){
			//limpiar al jugador del club origen
			//agregarlo al nuevo
			//resetear sus partidos jugados
			//La transferencia afecta a la cantidad de socios de ambos clubes 
		}
	}
}
class EquipoFutbol inherits Equipo{
	method cantDeMiembrosEstrella()=plantel.count({jugador=>jugador.soySocioEstrella()})
	override method disminucionDePuntosPorSanciones()=cantVecesSancionado*30
	override method evaluacion()=super()+(self.cantDeMiembrosEstrella()*5)
}
class Jugador {
	var property club
	var valorDelPase
	var property partidosJugados
	method soySocioEstrella()=partidosJugados>=20 or club.casoParticular(self)
}
class ActividadSocial {
	var valorDeEvaluacion
	var organizador
	var sociosParticipantes=#{organizador}
	var property suspendidaPorSancion
	method estaEsteMiembro(miembro)=sociosParticipantes.contains(miembro)
	method involucrados()=sociosParticipantes
	method sancionar(){suspendidaPorSancion=true}
	method quitarSancion(){suspendidaPorSancion=false}
	method evaluacion()=if(!suspendidaPorSancion) valorDeEvaluacion else 0
	method socioDestacado()=organizador
	method esPrestigioso()=sociosParticipantes.count({socio=>socio.soySocioEstrella()})>=5
}
class Socio{
	var tiempoEnLaInstitucion
	method soySocioEstrella()=tiempoEnLaInstitucion>20
}
