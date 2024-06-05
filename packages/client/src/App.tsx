import '../styles/globals.css'
import AreaControl, { IAreaControlData } from './AreaControl/AreaControl';
import KingOfTheHill, { IKingOfTheHillData } from './KingOfTheHill';
import Container from './components/Container'

export const App = () => {

  const kingOfTheHillData: IKingOfTheHillData = {
    timer: 0,
    runningTime: 0,
    currentKing: 'SampleUsername',
    claimable: true,
    receiveable: false,
  }

  const areaControlData: IAreaControlData = {
    teamACount: 2,
    teamBCount: 2,
    taken: true,
    taker: "B",
    teamAScore: 3600*24,
    teamBScore: 3600*12,
    userTeam: "A",
    haveToken: false,
  }

  

  return (
    <>
      <Container title='King of the Hill'>
        <KingOfTheHill data={kingOfTheHillData} />
      </Container>
      <Container title='Area Control'>
        <AreaControl data={areaControlData} />
      </Container>
    </>
  );
};
