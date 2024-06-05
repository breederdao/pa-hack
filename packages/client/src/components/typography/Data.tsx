import React, { ReactNode } from 'react';
import { cn } from '../../utils/cn';

interface DataProps {
  children: ReactNode;
  muted?: boolean;
}

const Data: React.FC<DataProps> = ({ children, muted=false }) => {
  return (
    <h2 className={cn(`font-normal text-3xl leading-[38px] text-center border-b-2 border-dusty-orange`,{
      ['text-dusty-orange']: !muted,
      ['text-walnut']: muted,
    })}>{children}</h2>
  )
}

export default Data;