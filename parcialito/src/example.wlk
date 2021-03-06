object valorASuperar{
	var property valor=0
}
class Club{
	var property actividadesDelClub=#{}
	var gastosDelClub=0
	method agregarActividad(unaActividad){
		actividadesDelClub.add(unaActividad)
	}
	method condicionParaSancionIntegral()=self.cantidadDeSociosTotales()>500
	method puntajeTotalDeEvaluacionesDeLasActividades()=actividadesDelClub.sum({actividad=>actividad.evaluacion()})
	method cantidadDeSociosTotales()=actividadesDelClub.map({actividad=>actividad.involucrados()}).asSet().flatten().size()
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
	method eliminarSocio(socio){
		actividadesDelClub.forEach({actividad=>actividad.eliminarSocio(socio)})
	}
}
class ClubProfesional inherits Club{
	override method casoParticular(jugador)=jugador.valorDelPase()>valorASuperar.valor()
	override method evaluacionBruta()=self.puntajeTotalDeEvaluacionesDeLasActividades()*2-(gastosDelClub*5)
}
class ClubTradicional inherits Club{
	override method casoParticular(jugador)=jugador.valorDelPase()>valorASuperar.valor() or self.aparecionesDe(jugador)>3
	//TODO como ver que sancione a un club o a una actividad dependiendo del gusto
	override method condicionParaSancionIntegral()=true
	override method evaluacionBruta()=self.puntajeTotalDeEvaluacionesDeLasActividades()-gastosDelClub
}
class ClubComunitario inherits Club{
	override method casoParticular(jugador)=self.aparecionesDe(jugador)>3
	override method evaluacionBruta()=self.puntajeTotalDeEvaluacionesDeLasActividades()
	
}
class Equipo {
	var property club
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
	method agregarJugador(socio){
		plantel.add(socio)
	}
	method eliminarSocio(socio){
		plantel.remove(socio)
	}
	method transferirJugador(_unJugador,equipo){
		if(self.esTrasferible(_unJugador,equipo)){
			_unJugador.club().eliminarSocio(_unJugador)
			 equipo.agregarJugador(_unJugador)
			_unJugador.partidosJugados(0)
			_unJugador.equipo(equipo)
		}
	}
}
class EquipoFutbol inherits Equipo{
	method cantDeMiembrosEstrella()=plantel.count({jugador=>jugador.soySocioEstrella()})
	override method disminucionDePuntosPorSanciones()=cantVecesSancionado*30
	override method evaluacion()=super()+(self.cantDeMiembrosEstrella()*5)
}
class Jugador {
	var property equipo=null
	var valorDelPase
	var property partidosJugados
	method soySocioEstrella()=partidosJugados>=20 or equipo.club().casoParticular(self)
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
	method eliminarSocio(socio){
		sociosParticipantes.remove(socio)
	}
}
class Socio{
	var tiempoEnLaInstitucion
	method soySocioEstrella()=tiempoEnLaInstitucion>20
}
